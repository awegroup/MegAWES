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

function handleParticles = animation_tether(Path_last_cycle,tether_last_cycle,index_set,Tend,fps,t)
%Animate tether shape
%
% :param Path_last_cycle: Aircraft position
% :param tether_last_cycle: Tether particle xyz positions
% :param index_set: Array containing the indices of the dataset that should be
%                used
% :param Tend: Video length
% :param fps: Frames per second
% :param t: animation time at particular step, provided by fanimator()
%
% :returns:
%           - **handleParticles** - Tether plot handle
%
% Example: 
%       | fanimator(axes1,@animation_tether,Path_last_cycle,Tether_last_cycle,Tend,...
%       |    fps,t,'AnimationRange',[0 Tend],'FrameRate',fps)
%
% | Other m-files required: None
% | Subfunctions (bottom): drawParticleTether
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
% Draw kite
pn = Path_last_cycle.Data(1,datapoint);
pe = Path_last_cycle.Data(2,datapoint);
pd = Path_last_cycle.Data(3,datapoint);

% Tether particle positions
p_t_x = [0;flipud(tether_last_cycle.Data(1).Data(:,datapoint));-pn];
p_t_y = [0;flipud(tether_last_cycle.Data(2).Data(:,datapoint)); pe];
p_t_z = [0;flipud(tether_last_cycle.Data(3).Data(:,datapoint));-pd];

handleParticles = drawParticleTether(p_t_x,p_t_y,p_t_z);

%------------- END CODE --------------
end

function handleParticles = drawParticleTether(p_t_x, p_t_y, p_t_z)
   handleParticles = plot3(p_t_x, p_t_y,p_t_z , '-', 'color', [0.1 0.1 0.1], 'Markersize',2, 'Linewidth', 1.2, 'MarkerFaceColor', [0.3 0.3 0.3]);
end