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

function y = extractSignalOfLastCycle_nD( signal, sample_count_last_cycle,  simInit )
%Extract n-D data from last converged power cycle.
%
% :param signal: Full n-D timeseries simulation output,size= nx1xtimeseries
% :param sample_count_last_cycle: Simulation timeseries 'sample_count_last_cycle'
% :param simInit: Simulation input structure 'simInit'
%
% :returns:
%           - **y** - Extracted power cycle n-D timeseries.
%
% Example: 
%    TetherX_last_cycle = extractSignalOfLastCycle_nD(Tether_x, cycle_signal_counter, simInit );
%
% | Other m-files required: none
% | Subfunctions: none
% | MAT-files required: none
%
% :Revision: January-2021
% :Author: Dylan Eijkelhof (d.eijkelhof@tudelft.nl)

%------------- BEGIN CODE --------------
time_window_last_cylce = sample_count_last_cycle.Data(1,1,end) * simInit.Ts_power_conv_check;
idx_time_window_start = find(signal.Time >= signal.Time(end)-time_window_last_cylce,1);

s = size(signal.Data);
if numel(s)==3
    one_pos = find(s==1,1);
    snew = s;
    snew(one_pos)=[];
    i_pos = find(s==min(snew));
    i_pos = i_pos(end);
    for i=1:s(i_pos)
        if i_pos==1
            if one_pos == 2
                y.Data(i,:) = signal.Data(i,1,idx_time_window_start:end);
            else
                y.Data(i,:) = signal.Data(i,idx_time_window_start:end,1);
            end
        elseif i_pos==2
            if one_pos == 1
                y.Data(i,:) = signal.Data(1,i,idx_time_window_start:end);
            else
                y.Data(i,:) = signal.Data(idx_time_window_start:end,i,1);
            end
        else
            if one_pos == 1
                y.Data(i,:) = signal.Data(1,idx_time_window_start:end,i);
            else
                y.Data(i,:) = signal.Data(idx_time_window_start:end,1,i);
            end
        end
    end
%     for i=1:size(signal.Data,1)
%         y.Data(i,:) = signal.Data(i,1,idx_time_window_start:end);
%     end
elseif numel(s)==2
    [~,i_pos] = min(s);
    for i=1:s(i_pos)
        if i_pos==1
            y.Data(i,:) = signal.Data(i,idx_time_window_start:end);
        else
            y.Data(i,:) = signal.Data(idx_time_window_start:end,i)';
        end
    end
else
    error('Input is not compatible')
end
    
y.Time = signal.Time(idx_time_window_start:end);
%------------- END CODE --------------
end