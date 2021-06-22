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

function y = extractSignalOfLastCycle2( signal, sample_count_last_cycle,  simInit )
%Extract 1D data from last converged power cycle.
%
% :param signal: Full 1D timeseries simulation output.
% :param sample_count_last_cycle: Simulation timeseries 'sample_count_last_cycle'.
% :param simInit: Simulation input structure 'simInit'.
%
% :returns:
%           - **y** - Extracted power cycle 1D timeseries.
%
% Example: 
%    P_mech_last_cycle = extractSignalOfLastCycle2(P_mech, cycle_signal_counter, simInit);
%
% | Other m-files required: none
% | Subfunctions: none
% | MAT-files required: none
%
% :Revision: December-2019
% :Authors: Sebastian Rapp, Dylan Eijkelhof (d.eijkelhof@tudelft.nl)

%------------- BEGIN CODE --------------
time_window_last_cylce = sample_count_last_cycle.Data(end) * simInit.Ts_power_conv_check;
idx_time_window_start = find(signal.Time >= signal.Time(end)-time_window_last_cylce,1);
y.Data = signal.Data(idx_time_window_start:end);
y.Time = signal.Time(idx_time_window_start:end);

%------------- END CODE --------------
end