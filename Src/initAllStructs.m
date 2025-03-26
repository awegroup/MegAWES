function simIn = initAllStructs(model, simInit, ENVMT, controllerGains_traction, ... 
    controllerGains_retraction, tetherParams, pathparam, ...
    actuatorLimit, winchParameter, MegAWESkite)
    % Initialize all structures and parameters for the Simulink simulation.
    %
    % Args:
    %     model (char): Name of the Simulink model to be initialized.
    %     simInit (struct): Structure containing simulation initialization parameters.
    %     ENVMT (struct): Structure containing environmental parameters.
    %     controllerGains_traction (struct): Structure containing controller gains for the traction phase.
    %     controllerGains_retraction (struct): Structure containing controller gains for the retraction phase.
    %     tetherParams (struct): Structure containing tether-specific parameters.
    %     pathparam (struct): Structure containing pattern-specific parameters.
    %     actuatorLimit (struct): Structure containing actuator limits.
    %     winchParameter (struct): Structure containing winch sizing and required controller parameters.
    %     MegAWESkite (struct): Structure containing kite-specific parameters.
    %
    % Returns:
    %     simIn (Simulink.SimulationInput): Initialized simulation input object containing the set model parameters 
    %         and workspace variables for the Simulink simulation.
    %
    % Notes:
    %     - The `simIn` object is configured with model parameters such as stop time and timeout.
    %     - All input structures are passed to the Simulink model's workspace.
    %     - This function does not execute the simulation but prepares the required inputs.
    %
    % Date:
    %     2025-01-15
    %
    % Authors:
    %     Dylan Eijkelhof (d.eijkelhof@tudelft.nl)
    simIn = Simulink.SimulationInput(model);
    
    simIn = simIn.setModelParameter('StopTime', sprintf('%d',simInit.simulationTime));
    simIn = simIn.setModelParameter('TimeOut', simInit.simTime_realTimeOut);
    simIn = simIn.setVariable('simInit',simInit,'Workspace',model);
    simIn = simIn.setVariable('ENVMT',ENVMT,'Workspace',model);
    simIn = simIn.setVariable('controllerGains_traction',controllerGains_traction,'Workspace',model);
    simIn = simIn.setVariable('controllerGains_retraction',controllerGains_retraction,'Workspace',model);
    simIn = simIn.setVariable('tetherParams',tetherParams,'Workspace',model);
    simIn = simIn.setVariable('pathparam',pathparam,'Workspace',model);
    simIn = simIn.setVariable('actuatorLimit',actuatorLimit,'Workspace',model); 
    simIn = simIn.setVariable('winchParameter',winchParameter,'Workspace',model); 
    simIn = simIn.setVariable('MegAWESkite',MegAWESkite,'Workspace',model);
     
end