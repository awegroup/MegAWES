% Copyright 2020 Delft University of Technology
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

%% Startup/Set cache folder
PreSim_startup();
clearvars                           % Clear workspace
close all                           % Close all figure windows
clc                                 % Clear command window

%% Set variables
[base_windspeed, constr, ENVMT, Lbooth, ...
    loiterStates, DE2019, simInit, T, winchParameter,params] = initAllSimParams_DE2019();

%% Run simulation untill power convergence
simout = sim('Pointmass_eom_v1_0.slx','ReturnWorkspaceOutputs','on'); %Matlab Simulink R2020a

% simout = sim('Pointmass_eom_v1_0_R2018B.slx','ReturnWorkspaceOutputs','on'); %Matlab Simulink R2018b

%% Results
if simout.power_conv_flag
    P_mech_last_cycle = extractSignalOfLastCycle2(simout.P_mech, ...
        simout.cycle_signal_counter, simInit);
    Path_last_cycle = extractSignalOfLastCycle3D(simout.pos_O, ...
        simout.cycle_signal_counter, simInit );
    Average_power = mean(P_mech_last_cycle.Data);
    Ft_last_cycle = extractSignalOfLastCycle2(simout.TetherForce, ...
        simout.cycle_signal_counter, simInit);
    if 0
        close all
        Offline_visualisation_power(P_mech_last_cycle,Path_last_cycle); %#ok<*UNRCH>
        LastcycleData_plot(Ft_last_cycle,'Tether force [N]','Cycle time [s]')
    end
end

%% Animate Flightpath

if 0 %1 to activate
    addpath(genpath('Extra'))
    P_mech_last_cycle = extractSignalOfLastCycle2(simout.P_mech, ...
        simout.cycle_signal_counter, simInit); %#ok<*UNRCH>
    Path_last_cycle = extractSignalOfLastCycle3D(simout.pos_O, ...
        simout.cycle_signal_counter, simInit );
    EulAng_last_cycle = extractSignalOfLastCycle_nD(simout.Eul_ang, ...
        simout.cycle_signal_counter, simInit );
    Tether_last_cycle_x = extractSignalOfLastCycle_nD(simout.Tether_x, ...
        simout.cycle_signal_counter, simInit );
    Tether_last_cycle_y = extractSignalOfLastCycle_nD(simout.Tether_y, ...
        simout.cycle_signal_counter, simInit );
    Tether_last_cycle_z = extractSignalOfLastCycle_nD(simout.Tether_z, ...
        simout.cycle_signal_counter, simInit );
    
%     filename = 'FileName.mp4'; % Create animation video, write to file
    filename = []; % Create figure to play animation
    Duration = 60;
    fps = 30;
    filename = animate_flightpath_torque(filename,P_mech_last_cycle,...
        Path_last_cycle,EulAng_last_cycle,Tether_last_cycle_x,...
        Tether_last_cycle_y,Tether_last_cycle_z,ENVMT,Duration,fps);
    if ~isempty(filename)
        movefile(filename,['Extra' filesep filename])
    end
    rmpath(genpath('Extra'))
end
% use the command: "playAnimation" (without quotes) to play the animation

%% Update previous version
%   If changes are made, update older version files for compatibility
%   this includes all model reference files, if any.

% addpath(genpath('Extra'))
% exportToPreviousVersion('Pointmass_eom_v1_0.slx','R2018B')
% movefile('Pointmass_eom_v1_0_R2018B.slx',...
% ['Extra' filesep 'Pointmass_eom_v1_0_R2018B.slx'])
% rmpath(genpath('Extra'))