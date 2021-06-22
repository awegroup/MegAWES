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

function handleLine = animation_colorbar(Power,index_set,Tend,fps,t)
%Animate instantaneous power on colorbar
%
% :param Path_last_cycle: Aircraft position
% :param index_set: Array containing the indices of the dataset that should be
%                used
% :param Tend: Video length
% :param fps: Frames per second
% :param t: animation time at particular step, provided by fanimator()
%
% :returns:
%           - **handleLine** - Line moving over colorbar plot handle
%
% Example: 
%       | h_axes = axes('Parent',fig_pow,'position', cb.Position, 'ylim', ...
%       |    cb.Limits, 'color', 'none', 'visible','off');
%       | fanimator(h_axes,@animation_colorbar,Power,Tend,...
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
elseif datapoint>numel(Power)
    datapoint = numel(Power);
elseif t == Tend
    datapoint = numel(Power);
end
% Current time
Pow = Power(datapoint);
if Pow>0
    color = 'black';
else
    color = 'red';
end

handleLine = plot([0 1], Pow*[1 1],'LineStyle','-','Marker','x','LineWidth', 6, 'color', color);
%------------- END CODE --------------
end