function simIn =    initAllStructs(model, base_windspeed, constr, ... 
    ENVMT, Lbooth, loiterStates, DE2019, simInit, T, winchParameter,params,act)
%Initialise simulation input variable.
%
% :param model: simulink model name (without .slx extension).
% :param base_windspeed: Wind speed at max altitude where speed stays constant.
% :param constr: Aircraft manoeuvre and winch constraints.
% :param ENVMT: Environmental parameters.
% :param Lbooth: Flight path parameters.
% :param loiterStates: Initial loiter parameters (power cycle initialisation).
% :param DE2019: Aircraft parameters.
% :param simInit: Simulation initialisation parameters.
% :param T: Tether dimensions and material properties.
% :param winchParameter: Winch dynamic parameters.
% :param params: Flight/Winch controller parameters.
% :param act: Actuator, aileron elevator and rudder data.
%
% :returns:
%           - **simIn** - Simulation input variable containing all parameters needed by simulink.
%
% Example:
%       | simIn = initAllStructs('Dyn_6DoF_v2_0_r2019b', base_windspeed, constr, ... 
%       |    ENVMT, Lbooth, loiterStates, DE2019, simInit, T, winchParameter,params,act)
%
% | Other m-files required: transformFromWtoO.m, transformFromOtoW.m, getPointOnBooth.m
% | Subfunctions: None
% | MAT-files required: Lib/Common/DE2019_params.mat, Lib/6DoF/Control_allocation_V60.mat, Lib/Common/winddata_Lidar_Avg.mat
%
% :Revision: 22-June-2021
% :Author: Dylan Eijkelhof (d.eijkelhof@tudelft.nl)
 
%------------- BEGIN CODE --------------

simIn = Simulink.SimulationInput(model);

simIn = simIn.setVariable('base_windspeed',base_windspeed,'Workspace',model);
simIn = simIn.setVariable('constr',constr,'Workspace',model); 
simIn = simIn.setVariable('ENVMT',ENVMT,'Workspace',model); 
simIn = simIn.setVariable('Lbooth',Lbooth,'Workspace',model);
simIn = simIn.setVariable('loiterStates',loiterStates,'Workspace',model);
simIn = simIn.setVariable('DE2019',DE2019,'Workspace',model);
simIn = simIn.setVariable('simInit',simInit,'Workspace',model);
simIn = simIn.setVariable('T',T,'Workspace',model);
simIn = simIn.setVariable('winchParameter',winchParameter,'Workspace',model);
simIn = simIn.setVariable('params',params,'Workspace',model); 
simIn = simIn.setVariable('act',act,'Workspace',model); 

simIn = simIn.setModelParameter('TimeOut', simInit.TSIM);
%------------- END CODE --------------
end