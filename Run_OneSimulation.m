% Copyright 2021 Delft University of Technology
%
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%
%      http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License. 

%% Instructions

% This code can be run to run a simulation at one wind speed.
% Startup/Set cache folder section clears the workspace and set the correct
% cache folder.
% Set variables section is used to choose between 3 or 6 DoF kite dynamics
% Also the wind speed is can be chosen accordingly.
% After this there is not much that should be changed. One can decide to turn
% certain plots on and of by setting the corresponding if statement to 1 or 0.
%% Startup/Set cache folder
addpath(['Src' filesep 'Common'])
PreSim_startup();
clearvars                           % Clear workspace
close all                           % Close all figure windows
clc                                 % Clear command window

%% Set variables

Kite_DOF = 6; % Kite degrees of freedom: 3 (point-mass) or 6 (rigid-body)
% 3DoF: Forced to 22m/s
% 6DoF: 8m/s  10m/s  14m/s  16m/s  18m/s  20m/s  22m/s  25m/s  28m/s  30m/s
windspeed = 22; 

[act, base_windspeed, constr, DE2019, ENVMT, Lbooth, ...
	loiterStates, params, simInit, T, winchParameter] = ...
	Get_simulation_params(windspeed, Kite_DOF);

%% Run simulation untill average pumping cycle power convergence
if Kite_DOF==6
    simOut = sim('Dyn_6DoF_v2_0_r2019b.slx',...
        'SrcWorkspace', 'current'); %Matlab Simulink R2019b

    % simOut = sim('Dyn_6DoF_v2_0_R2015B.slx',...
    %     'SrcWorkspace', 'current'); %Matlab Simulink R2018b
elseif Kite_DOF==3
    %Matlab Simulink R2019b
    simOut = sim('Dyn_PointMass_r2019b.slx',...
        'SrcWorkspace', 'current'); 
    
    %Matlab Simulink R2018b
    % simOut = sim('Dyn_PointMass_R2015B.slx',...
    %     'SrcWorkspace', 'current'); 
else
    error('Wrong number of Degrees of Freedom entered')
end

% Show elapsed time by running simulink.
disp(['Total elapsed walltime is: ',...
    num2str(simOut.SimulationMetadata.TimingInfo.TotalElapsedWallTime),...
    ' seconds'])

%% Results visualisation, figures, video or animation object(matlab figure)
if simOut.power_conv_flag
    %% Power and flight path for last pumping cycle
    P_mech_last_cycle = extractSignalOfLastCycle2(simOut.P_mech, ...
        simOut.cycle_signal_counter, simInit);
    Path_last_cycle = extractSignalOfLastCycle_nD(simOut.pos_O, ...
        simOut.cycle_signal_counter, simInit );
    Average_power = mean(P_mech_last_cycle.Data);

    if 1
        close all
        [fig_PO, fig_flightpower] = Offline_visualisation_power(...
            P_mech_last_cycle,Path_last_cycle); %#ok<*UNRCH>
    end

    %% Theoretical check: 
    % Loyd peak power
    % Costello et al. (2015) restrictive average power
    
    if 1
        try %#ok<TRYNC>
            if ishandle(fig_PO)
                fig_PO = Theoretical_Pcheck(simOut,constr,ENVMT,DE2019,simInit,T,params,fig_PO);
            end
        end
    end

    %% Animate Flightpath (Video)

    if 0 %1 to activate
        %%% !!!Create animation video, write to file
%         filename = [num2str(Average_power/1e6,3) 'MW_6DOF_2.mp4']; 
        
        %%% !!!Create figure to only play the animation
        filename = [];

        duration = 30; %seconds
        Video_from_simOut(filename, simOut,simInit,ENVMT,DE2019,duration)
    end
    
    % Wait for 'done' in the command window before trying to play the animation
    % Then use the command: "playAnimation" (without quotes) to play the animation
else
    warning('Simulation did not converge')
end