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

function PreSim_startup()
%Set search path, simulink cache folder and clear variables
%
% :returns: None
%
% Example: 
%    PreSim_startup();
%
% | Other m-files required: None
% | Subfunctions: None
% | MAT-files required: None
%
% :Revision: 17-September-2020
% :Author: Dylan Eijkelhof (d.eijkelhof@tudelft.nl)
 
%------------- BEGIN CODE --------------

restoredefaultpath                  % To make sure path contains the right files
Simulink.fileGenControl('reset');   % Reset simulink cache preferences

% Add all required folders/files to search path
addpath(genpath('Lib'))
addpath(genpath('Src'))
addpath(genpath('Extra'))

% Setting cachefolder 
cfg = Simulink.fileGenControl('getConfig'); 

cachefolder = 'Cache_temp';
if ~exist(cachefolder, 'dir')
   mkdir(cachefolder)
end
cfg.CacheFolder = [pwd '/' cachefolder];
Simulink.fileGenControl('setConfig', 'config', cfg)
clear cfg cachefolder

%------------- END CODE --------------
end
