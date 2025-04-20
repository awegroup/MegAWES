function costOut = getCost_new(optsIN, simOut, simInit, tetherForceMax, alphamax)
    % Compute the cost of a simulation based on performance metrics and constraints.
    %
    % Args:
    %     optsIN (double): Input matrix defining the design variables for the simulation.
    %     simOut (Simulink.SimulationOutput): Simulation output object containing various timeseries data and flags.
    %     simInit (struct): Structure containing simulation initialisation parameters.
    %     tetherForceMax (double): Maximum allowable tether force in newtons.
    %     alphamax (double): Maximum allowable angle of attack in degrees.
    %
    % Returns:
    %     costOut (9x1 double): A matrix with rows representing various computed metrics:
    %         - (1,1): Tether force penalty.
    %         - (2,1): Cross-track error penalty.
    %         - (3,1): Angle of attack penalty.
    %         - (4,1): Velocity penalty.
    %         - (5,1): Peak-to-average power ratio penalty.
    %         - (6,1): Number of completed power cycles.
    %         - (7,1): Mean mechanical power during traction phase.
    %         - (8,1): Convergence flags (1 if converged, 0 otherwise).
    %         - (9,1): Total cost for each design configuration.
    %
    % Notes:
    %     - Penalties are applied if performance constraints are violated.
    %     - Signals from the last converged power cycle are used for the evaluation.
    %
    % Date:
    %     2024-10-31
    %
    % Authors:
    %     Dylan Eijkelhof (d.eijkelhof@tudelft.nl)

    alphamax = alphamax*pi/180;
    Ctemax = 75; 
    velmax = 100;  
    PAPRmax = 2.5;
    
    pVel = zeros(1,size(optsIN,2));  %velocity
    % pCft = zeros(1,size(x,2));  %crest factor during traction
    %plal = zeros(1,size(x,2));  %low altitude (100m)
    pCte = zeros(1,size(optsIN,2));  %Cross track error traction
    pAoA = zeros(1,size(optsIN,2));
    pTether = zeros(1,size(optsIN,2));
    pPAPR = zeros(1,size(optsIN,2));
    mPower = zeros(1,size(optsIN,2));
    Convergence = zeros(1,size(optsIN,2));
    cost = zeros(1,size(optsIN,2));
    no_cycles = zeros(1,size(optsIN,2));
    for i = 1:size(optsIN,2)
        if (isempty(simOut(i).power_conv_flag)) %initialization 
            pTether(i) = 1e8;
            pAoA(i) = 1e8;
            pCte(i) = 1e8;
    %         pCft(i) = 1e8;
            pVel(i) = 1e8;
            pPAPR(i) = 1e8;
            mPower(i) = 0;
            Convergence(i) = 0;
            no_cycles(i) = 0;
        else
            if (double(simOut(i).power_conv_flag))==0
                time_factor = simOut(i).P_mech.Time(end)/simInit.simulationTime;
                pen = 1e6/time_factor;
                pTether(i) = pen;
                pAoA(i) = pen;
                pCte(i) = pen;
    %         pCft(i) = pen;
                pVel(i) = pen;
                pPAPR(i) = pen;
                mPower(i) = 0; % make it different for each run but still artificial number
                try
                    if simOut(i).No_of_Cycles >= 1
                        mPower(i) = simOut(i).No_of_Cycles^3 * 1e2;
                    else
                        mPower(i) = 0;
                    end
                catch
                    %
                end
                Convergence(i) = 0;
                no_cycles(i) = simOut(i).No_of_Cycles;
            else
                %% Extracting the signal segments of the last cycle.
                % Mechanical power
                P_mech_last_cycle = extractSignalOfLastCycle2(simOut(i).P_mech, ...
                    simOut(i).cycle_signal_counter, simInit );
                
                TetherForce_last_cycle = extractSignalOfLastCycle2( simOut(i).TetherForce,...
                    simOut(i).cycle_signal_counter, simInit );
                
                Aoa_last_cycle = extractSignalOfLastCycle2( simOut(i).AoA,...
                    simOut(i).cycle_signal_counter, simInit );
                
                Cte_last_cycle = extractSignalOfLastCycle2( simOut(i).Crosstrackerr,...
                    simOut(i).cycle_signal_counter, simInit );
                
                Vel_last_cycle = extractSignalOfLastCycle2( simOut(i).Vel,...
                    simOut(i).cycle_signal_counter, simInit );
                
                Fstate_last_cycle = extractSignalOfLastCycle2(simOut(i).Fstate, ...
                    simOut(i).cycle_signal_counter, simInit );
                
                
                % Penalties
                pen_ft_constr_viol = 1e4;
                pen_vel = 1e4;
                pen_aoa = 1e2;
                pen_cte = 1e2;
                pen_papr = 1e4;
                
    %             pen_cft = 1e2;
    
                %% Control performance: If within limits - no penalty
                % penalty only if exceeds a certain boundary *
                % Cross track error traction 
                pCte(i) = pen_cte * max(max(Cte_last_cycle.Data)/Ctemax -1,0);
                %% Hard constraints: violation flag is directly set in Simulink
                % Angle of attack 
                pAoA(i) =  pen_aoa * max(max(Aoa_last_cycle.Data)/alphamax -1, 0);
                % Tetherforce
                pTether(i) = pen_ft_constr_viol * max(max(TetherForce_last_cycle.Data)/tetherForceMax - 1, 0);
                
                %Velocity 
                pVel(i) = pen_vel * max(max(Vel_last_cycle.Data)/velmax - 1, 0);
                
                % Peak to average power ratio
                P_mech_traction = P_mech_last_cycle.Data;
                mean_P_mech_traction = mean(P_mech_traction);
                PAPR = (max(P_mech_traction)/mean_P_mech_traction);
                pPAPR(i) = pen_papr * max(PAPR/PAPRmax - 1, 0);
                
                %% Final power scaling   
                mPower(i) = mean(P_mech_last_cycle.Data); %*100
                Convergence(i) = 1;
                no_cycles(i) = simOut(i).No_of_Cycles;
            end
        end
        cost(i) = - mPower(i) + pTether(i) + pCte(i) + pAoA(i) + pVel(i) + pPAPR(i); 
    end
    
    costOut = [pTether; pCte; pAoA; pVel; pPAPR; no_cycles; mPower; Convergence; cost]; % numb of this need to be checked with runOneGen2

end