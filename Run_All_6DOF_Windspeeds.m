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

%% Startup/Set cache folder
addpath(['Src' filesep 'Common'])
PreSim_startup();
clearvars                           % Clear workspace
close all                           % Close all figure windows
clc                                 % Clear command window

%% Set variables
Kite_DOF = 6; % Kite degrees of freedom

try %#ok<TRYNC>
c = parcluster('local');
c.NumWorkers = 8; % Number of available cores
parpool(c, c.NumWorkers);
end

%% Set variables
windspeeds = [8 10 14 16 18 20 22 25 28 30];
for i = 1:numel(windspeeds)
    [act, base_windspeed, constr, DE2019, ENVMT, Lbooth, ...
        loiterStates, params, simInit, T, winchParameter] = ...
        Get_simulation_params(windspeeds(i),Kite_DOF);
    simInP = initAllStructs('Dyn_6DoF_v2_0_r2019b', base_windspeed, ...
        constr, ENVMT, Lbooth, loiterStates, DE2019, simInit, T, ...
        winchParameter,params,act);
    simIn(i) = simInP;    
end

simOut = parsim(simIn);

for j = 1:numel(simOut)
    P_mech_last_cycle = extractSignalOfLastCycle2(simOut(j).P_mech, ...
        simOut(j).cycle_signal_counter, simInit);
    Average_power(j) = mean(P_mech_last_cycle.Data);
%     disp([num2str(vw) ' m/s done!'])
end
save('out_power_all.mat','Average_power','windspeeds')
% save('out_power_all.mat','Average_power','windspeeds', 'simOut') %Large output