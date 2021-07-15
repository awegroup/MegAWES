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

function Video_from_simOut(filename, simOut,simInit,ENVMT,DE2019,duration)
%Create an animation object or video from sim output
%
% :param filename: Name of the video file, including extension
%                  If [] is provided, no video file is created
% :param simOut: Simulink simulation output
% :param simInit: Simulation initialisation parameters
% :param ENVMT: Environmental parameters
% :param DE2019: Aircraft parameters
% :param duration: Length of video in seconds, it influences the number of datapoints to include
%
% :returns:
%           - **noVar** - Video file
%
% Example: 
%       | Video_from_simOut('test.mp4', simOut,simInit,ENVMT,DE2019,30)
%       | 
%       | Video_from_simOut([], simOut,simInit,ENVMT,DE2019,30)
%
% | Other m-files required: animate_flightpath.m, extractSignalOfLastCycle2.m, extractSignalOfLastCycle3D.m, extractSignalOfLastCycle_nD.m
% | Subfunctions: None
% | MAT-files required: None
%
% :Revision: 16-March-2021
% :Author: Dylan Eijkelhof (d.eijkelhof@tudelft.nl)

%------------- BEGIN CODE --------------

        % Gather variables from simulation output
        P_mech_last_cycle = extractSignalOfLastCycle2(simOut.P_mech, ...
            simOut.cycle_signal_counter, simInit); %#ok<*UNRCH>
        Path_last_cycle = extractSignalOfLastCycle3D(simOut.pos_O, ...
            simOut.cycle_signal_counter, simInit );
        EulAng_last_cycle = extractSignalOfLastCycle_nD(simOut.Eul_ang, ...
            simOut.cycle_signal_counter, simInit );
        Tether_last_cycle_x = extractSignalOfLastCycle_nD(simOut.Tether_x, ...
            simOut.cycle_signal_counter, simInit );
        Tether_last_cycle_y = extractSignalOfLastCycle_nD(simOut.Tether_y, ...
            simOut.cycle_signal_counter, simInit );
        Tether_last_cycle_z = extractSignalOfLastCycle_nD(simOut.Tether_z, ...
            simOut.cycle_signal_counter, simInit );

        fps = 30; %frames per second
        
        filename = animate_flightpath(filename,P_mech_last_cycle,...
            Path_last_cycle,EulAng_last_cycle,Tether_last_cycle_x,...
            Tether_last_cycle_y,Tether_last_cycle_z,ENVMT,DE2019.b,duration,fps);
        if ~isempty(filename)
            movefile(filename,['Extra' filesep filename])
        end
        
%------------- END CODE --------------
end

