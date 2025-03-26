% Main simulation execution script based on given yaml inputs (Lib)
%
% Returns:
%     simOut (Simulink.SimulationOutput): Simulation output structure containing various timeseries data and flags.
%
% Author:
%      Dylan Eijkelhof (d.eijkelhof@tudelft.nl)
%
% Date:
%     2025-01-15

%% Set folder dependencies
directoriesToAdd = {'Lib','Src'};
initialiseWorkspaceAndFolders(directoriesToAdd)

%% Sim init
model = 'simL0_multiPath';
load_system(model);

%% Importing input parameters
MegAWESkite = yaml.ReadYaml('MegAWESkite.yaml',false,true);
% fileName_simInput = 'figure8down_simInput.yaml';
fileName_simInput = 'fig8down_simInput.yaml';

[simInit, ENVMT, controllerGains_traction, ... 
    controllerGains_retraction, tetherParams, pathparam, ...
    actuatorLimit, winchParameter] = ...
    runParamSim(fileName_simInput, MegAWESkite);

simInit.doPlot = true; %Override

%%
simIn = initAllStructs(model, simInit, ENVMT, controllerGains_traction, ... 
    controllerGains_retraction, tetherParams, pathparam, ...
    actuatorLimit, winchParameter, MegAWESkite);

%% Run simulation


simOut = sim(simIn(1),'UseFastRestart',false);


% tetherParams.tether_inital_lenght = tetherParams.tether_inital_lenght+10;
% tetherParams.Tn_vect(3) = 1000;
% [tetherPos, Ft_Ground, Ft_Kite, Fvec, x, exitFlag]= ...
%     Tether_QuasiStatic2(simInit.pos_W_init, simInit.iniVel', zeros(3,tetherParams.numParticles), ...
%     tetherParams.tether_inital_lenght, tetherParams.Tn_vect, ENVMT, tetherParams);