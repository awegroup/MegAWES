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

function handleTime = animation_simtime(Path_last_cycle,pos,index_set,Tend,fps,t)
%animation_simtime - Animate timer according to datapoint time
%
% Inputs:
%    Path_last_cycle - Aircraft position
%    Pos - timer position on figure
%    index_set - Array containing the indices of the dataset that should be
%                used
%    Tend - Video length
%    fps - Frames per second
%    t - animation time at particular step, provided by fanimator()
%
% Outputs:
%    handleTime - Textbox plot handle
%
% Other m-files required: none
% Subfunctions (bottom): none
% MAT-files required: None
%
% Author: Dylan Eijkelhof, M.Sc.
% Delft University of Technology
% email address: d.eijkelhof@tudelft.nl  
% September 2020; Last revision: 17 September 2020

%------------- BEGIN CODE --------------

datapoint = index_set(round(((t/(1/fps))+1)));
if t == 0
    datapoint = 1;
elseif datapoint>size(Path_last_cycle.Data,2)
    datapoint = size(Path_last_cycle.Data,2);
elseif t == Tend
    datapoint = size(Path_last_cycle.Data,2);
end
% Current time
simtime = Path_last_cycle.Time(datapoint)-Path_last_cycle.Time(1);

handleTime = text(pos(1), pos(2),pos(3), {['   Simulation time: ' num2str(simtime)],' '},...
    'Clipping', 'on', 'Horiz', 'left', 'Vert', 'bottom',...
    'FontSize',20);

%------------- END CODE --------------
end