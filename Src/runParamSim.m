%% run parallel simulation

function [simInit, ENVMT, controllerGains_traction, ... 
    controllerGains_retraction, tetherParams, pathparam, ...
    actuatorLimit, winchParameter] = ...
    runParamSim(fileName, MegAWESkite, listvars, optsIN, paramUbounds, ...
    Int_listvars)
    % Converting simulation inputs to the correct structure for
    % simulink.
    %   Input files (yaml) is converted to the right structure for the
    %   simulink model. All inputs are determined in this function. if more
    %   than two arguments are provided, 3rd - 5th all have to be provided
    %   at minimum. 6th argument is always optional or can be an empty cell
    %   array.
    %
    % Args:
    %     fileName (char): Simulation input yaml filename.
    %     MegAWESkite (struct): Structure containing kite specific parameters, imported from MegAWESkite.yaml file.
    %     listvars (Optional, mx1 cell): Variable names that can vary during optimisation.
    %     optsIN (Optional, mx1 double): Normalised values corresponding to listvars to overwrite the default.
    %     paramUbounds (Optional, mx1 double): Optimisation upper boundaries corresponding to listvars to scale the optsIN values.
    %     Int_listvars (Optional, ?x1 cell): Variable names which corresponding values have to be converted to discrete values (integers).
    %
    % Returns:
    %     simInit (struct): Structure containing simulation initialisation parameters.
    %     ENVMT (struct): Structure containing environmental parameters.
    %     controllerGains_traction (struct): Structure containing required controller gains for the traction phase.
    %     controllerGains_retraction (struct): Structure containing required controller gains for the retraction phase.
    %     tetherParams (struct): Structure containing tether specific parameters.
    %     pathparam (struct): Structure containing pattern specific parameters.
    %     actuatorLimit (struct): Structure containing actuator limits.
    %     winchParameter (struct): Structure containing winch sizing and required controller parameters.
    %
    % Author:
    %      Dylan Eijkelhof (d.eijkelhof@tudelft.nl)
    %
    % Date:
    %     2024-10-31
    %% Import Data
    
    simInput = yaml.ReadYaml(fileName,false,true);

    % List of required fields
    requiredFields = {'simInit', 'ENVMT', 'controllerGains_traction', ...
        'controllerGains_retraction', 'tetherParams', 'pathparam', ...
        'actuatorLimit', 'winchParameter'};

    % Loop through each required field
    for i = 1:length(requiredFields)
        field = requiredFields{i};

        % Check if the field exists in the structure
        if ~isfield(simInput, field)
            error(['runParamWing: simInput missing required field: ' field]);
        end
    end
    
    simInit = simInput.simInit;
    ENVMT = simInput.ENVMT;
    controllerGains_traction = simInput.controllerGains_traction;
    controllerGains_retraction = simInput.controllerGains_retraction;
    tetherParams = simInput.tetherParams;
    pathparam = simInput.pathparam;
    actuatorLimit = simInput.actuatorLimit;
    winchParameter = simInput.winchParameter;
    
    %% Optimisation: overwrite values
    if nargin>2
        if nargin<6
            Int_listvars = {};
        end
        for j = 1:numel(listvars)
            if ismember(listvars{j}, Int_listvars)
                value = round(optsIN(j)*paramUbounds(j));
            else
                value = round(optsIN(j)*paramUbounds(j),6,'significant');
            end
            eval([listvars{j} '=' num2str(value,6) ';'])
        end
    end
    
    %% Environment parameteres MegAWES
    % Data and parameters copied from MegAwes (initAllSimParams_DE2019.m)
    winddata = yaml.ReadYaml('winddata_Lidar_Avg.yaml',false,true);

    ENVMT.wind_height = winddata.h;
    ENVMT.wind_data = winddata.vw_norm_metmast_ijmuiden;
    ENVMT.height_max = winddata.h(ENVMT.wind_data==max(ENVMT.wind_data)); 
    % keep wind speed constant from this height,  250m for ijmuiden, 500m for cabauw

    %% Aircraft position and attitude
    
    [simInit.pos_W_init, pathparam.retractionTarget_W] = ...
        determine_startPos_retractTarget(pathparam, tetherParams);
    pathparam.retractionTarget = ...
        transformFromWtoO(ENVMT.windDirection_rad, ...
        pathparam.retractionTarget_W);
    
%     simInit.pos_W_init(2)=0;

    simInit.pos_O_init = transformFromWtoO(ENVMT.windDirection_rad, simInit.pos_W_init)';

    sideslip = simInit.sideSlipAngle_rad; % initial sideslip
    simInit.iniEul = [0/180*pi,0/180*pi,90/180*pi+sideslip];

    elevation=asin(simInit.pos_W_init(3)/norm(simInit.pos_W_init));
    simInit.iniEul(1) = -(pi/2 - elevation);
    vWindHeight = ENVMT.base_windspeed*interp1(ENVMT.wind_height,ENVMT.wind_data,simInit.pos_W_init(3));
    simInit.iniVel = simInit.vel_B_init_noWind';
    velAircraftI = simInit.iniVel(1);
    simInit.iniEul(2) = -atan(vWindHeight/velAircraftI); % initial pitch
%     simInit.iniEul(2) = deg2rad(MegAWESkite.MainWing.alphaMax*0.75); % initial pitch

    iniVelWind = velAircraftI*[0,-sin(sideslip),sin(simInit.iniEul(2))];
    simInit.iniVel = simInit.iniVel + iniVelWind;

    psi_init = ENVMT.windDirection_rad+pi;
    if psi_init > pi
        psi_init = ENVMT.windDirection_rad-pi;
    end
    simInit.eta_init = [0;0;psi_init];% Theta = theta_,
    simInit.long_init = atan2( simInit.pos_W_init(2), simInit.pos_W_init(1) );
    simInit.lat_init = asin( simInit.pos_W_init(3)/norm(simInit.pos_W_init) );

    %constraints
    tetherParams.forceMax = 0.9*MegAWESkite.max_lift;

    %tether parameters
    SFt = tetherParams.safetyFactor; % Safety Factor
    sigmat = tetherParams.ultimateStrength; % % Kite power fact sheet: Dyneema® high-strength, high-modulus polyethylene fiber
    rho_tether = tetherParams.densityMaterial; %kg/m3 % Kite power fact sheet: Dyneema® high-strength, high-modulus polyethylene fiber

    tetherParams.d_tether = sqrt(tetherParams.forceMax/(sigmat/(4/pi*SFt)));
    tetherParams.rho_t = rho_tether * (pi/4*tetherParams.d_tether^2); %kg/m 

    E = tetherParams.modulusE; % Kite power fact sheet: Dyneema® high-strength, high-modulus polyethylene fiber
    tetherParams.A = (pi/4*tetherParams.d_tether^2);

    l_j = norm(simInit.pos_W_init);
    phi_init = atan2(simInit.pos_W_init(2),sqrt(l_j^2-simInit.pos_W_init(2)^2));
    if abs(phi_init)<1e-5
        phi_init = 0;
    end
    theta_init = atan2(simInit.pos_W_init(1),simInit.pos_W_init(3));

    tetherParams.Tn_vect = [theta_init; phi_init; 0.002*E*tetherParams.A]; %theta,phi,force magnitude

    tetherParams.tether_inital_lenght = norm(simInit.pos_O_init);
    tetherParams.l0 = tetherParams.tether_inital_lenght/(tetherParams.numParticles+1);
    tetherParams.pos_p_init = [];
    e_t = simInit.pos_W_init/norm(simInit.pos_W_init);
    for p = 1 : tetherParams.numParticles
        tetherParams.pos_p_init = [tetherParams.pos_p_init, p*e_t*tetherParams.l0];
    end
    tetherParams.pos_p_init = fliplr(tetherParams.pos_p_init);
end