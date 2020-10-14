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

function y = extractSignalOfLastCycle_nD( signal, sample_count_last_cycle,  simInit )
%extractSignalOfLastCycle_nD - Extract n-D data from last converged power cycle.
%
% Syntax:  extractSignalOfLastCycle_nD( signal, sample_count_last_cycle,  simInit )
%
% Inputs:
%    signal                     - Full n-D timeseries simulation output,size= nx1xtimeseries
%    sample_count_last_cycle    - Simulation timeseries 'sample_count_last_cycle'
%    simInit                    - Simulation input structure 'simInit'
%
% Outputs:
%    y - Extracted power cycle n-D timeseries
%
% Example: 
%    Path_last_cycle = extractSignalOfLastCycle_nD(Tether_x, cycle_signal_counter, simInit );
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% Author: Dylan Eijkelhof, M.Sc.
% Delft University of Technology
% email address: d.eijkelhof@tudelft.nl  
% December 2019; Last revision: May-2020

%------------- BEGIN CODE --------------
time_window_last_cylce = sample_count_last_cycle.Data(1,1,end) * simInit.Ts_power_conv_check;
idx_time_window_start = find(signal.Time >= signal.Time(end)-time_window_last_cylce,1);
for i=1:size(signal.Data,1)
    y.Data(i,:) = signal.Data(i,1,idx_time_window_start:end);
end
y.Time = signal.Time(idx_time_window_start:end);
%------------- END CODE --------------
end