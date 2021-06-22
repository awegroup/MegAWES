function [ENVMT, simInit, T] = initAllSimParams_WindCatenary(ENVMT, simInit, T)
%initAllSimParams_WindCatenary - Update parameters to fit test case
%
% Inputs:
%    ENVMT      - Environmental parameters
%    simInit    - Simulation initialisation parameters
%    T          - Tether dimensions and material properties
%
% Outputs:
%    simInit    - Simulation initialisation parameters [Updated time&position]
%    T          - Tether dimensions and material properties [Updated positions]
%    ENVMT      - Environmental parameters [Updated gravitational constant]
%
% Other m-files required: transformFromWtoO.m
%                         solve_cat.m (Catenary_3D folder)
% Subfunctions: none
% MAT-files required: none
%
% Example:  [ENVMT, simInit, T] = initAllSimParams_WindCatenary(ENVMT, simInit, T)
%
% Author: Dylan Eijkelhof, M.Sc.
% Delft University of Technology
% email address: d.eijkelhof@tudelft.nl  
% March 2021; Last revision: 17-March-2021

%------------- BEGIN CODE --------------

%% Initialization parameters
simInit.TSIM = 10; % Simulation Time 
simInit.dt= 0.005; % Step size

simInit.pos_W_init =  [0;0;300];
simInit.pos_O_init = transformFromWtoO(ENVMT.windDirection_rad, simInit.pos_W_init)'; %[-200,0,-250];
simInit.vel_B_init= [0;0;0];
simInit.long_init = atan2( simInit.pos_W_init(2), simInit.pos_W_init(1) );
simInit.lat_init = asin( simInit.pos_W_init(3)/norm(simInit.pos_W_init) );

%% Update tether parameters
l_j = norm(simInit.pos_W_init);
phi_init = atan2(simInit.pos_W_init(2),sqrt(l_j^2-simInit.pos_W_init(2)^2));
if abs(phi_init)<1e-5
    phi_init=0;
end
theta_init = atan2(simInit.pos_W_init(1),simInit.pos_W_init(3));

T.Tn_vect = [theta_init; phi_init; 0.002*T.E*T.A]; %theta,phi,force magnitude

T.tether_inital_lenght = norm( simInit.pos_O_init);
T.stoplength = T.tether_inital_lenght+50;
T.l0 = T.tether_inital_lenght/(T.np+1);
T.pos_p_init = [];
e_t = simInit.pos_W_init/norm(simInit.pos_W_init);
for p = 1 : T.np
    T.pos_p_init = [T.pos_p_init, p*e_t*T.l0];
end
T.pos_p_init = fliplr(T.pos_p_init);

%% Catenary

[x_catenary,y_catenary,z_catenary] = solve_cat([0;0;0],[simInit.pos_W_init(3);0;0],T.stoplength);

simInit.x_catenary = -z_catenary;
simInit.y_catenary = 0.*y_catenary;
simInit.z_catenary = x_catenary;

%% Gravity off
ENVMT.g = 1e-10; %Turn gravity off
end