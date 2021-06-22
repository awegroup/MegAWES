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

function handleTime = animation_simtime(Path_last_cycle,pos,index_set,Tend,fps,t)
%Animate timer according to datapoint time
%
% :param Path_last_cycle: Aircraft position
% :param Pos: timer position on figure
% :param index_set: Array containing the indices of the dataset that should be
%                used
% :param Tend: Video length
% :param fps: Frames per second
% :param t: animation time at particular step, provided by fanimator()
%
% :returns:
%           - **handleTime** - Textbox with simulation time plot handle
%
% Example: 
%       | TimePos = [0.6*limitx(2), limity(2), limitz(2)];
%       | fanimator(axes1,@animation_simtime,Path_last_cycle,TimePos,index_set,Tend,...
%       |    fps,t,'AnimationRange',[0 Tend],'FrameRate',fps)
%
% | Other m-files required: None
% | Subfunctions: None
% | MAT-files required: None
%
% :Revision: 17-September-2020
% :Author: Dylan Eijkelhof (d.eijkelhof@tudelft.nl)
 
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

handleTime = text(pos(1), pos(2),pos(3), {['   Simulation time: ' num2str(simtime) ' s'],' '},...
    'Clipping', 'on', 'Horiz', 'left', 'Vert', 'bottom',...
    'FontSize',20);

%------------- END CODE --------------
end