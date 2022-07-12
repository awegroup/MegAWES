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

%% Update previous version
%   If changes are made, update older version files for compatibility
%   this includes all model reference files, if any.
%   Older versions are never tested, thus compatibility is not guaranteed

simFileName = 'Dyn_PointMass_r2019b';
% simFileName = 'Dyn_6DoF_v2_0_r2019b';
simTargetVersion = 'R2015B';

exportToPreviousVersion([simFileName, '.slx'],simTargetVersion)
[filepath,~,~] = fileparts(which([simFileName, '.slx']));
movefile([simFileName(1:end-7), '_', simTargetVersion, '.slx'],...
         [filepath, filesep, simFileName(1:end-7), '_', simTargetVersion, '.slx'])