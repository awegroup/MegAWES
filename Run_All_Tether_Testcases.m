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

%% Startup/Set cache folder
addpath(['Src' filesep 'Common'])
PreSim_startup();
clearvars                           % Clear workspace
close all                           % Close all figure windows
clc                                 % Clear command window

addpath(genpath('Additional_tests')) % Add needed simulation files to the path
status = [];

%% Run each test consecutively
% - Drag catenary curve test: Comparison to a rotated hanging cable, 
%       catenary curve (Drag only)
% - Tether pull free-rotation winch test: Pulling tether up with prescribed
%       force, comparing to analytical tether length at force balance 
%       (gravity only)
% - Tether gravitational fall test: Test whether tether falls at
%       gravitational constant (gravity only)
% - Tether catenary curve test: Comparison to hanging cable at 2 different
%       altitudes, catenary curve 
%       (gravity only)

if 1
disp(' ')
disp('Drag catenary curve test:')
disp(' ')
tic
status = [status, Run_drag_curve()];
toc
end

if 1
disp(' ')
disp(' ')
disp('Tether pull free-rotation winch test (could take approx 3 min.):')
disp(' ')
tic
status = [status, Run_tether_pull()];
toc
end

if 1
disp(' ')
disp(' ')
disp('Tether gravitational fall test:')
disp(' ')
tic
status = [status, Run_tether_fall2()];
toc
end

if 1
disp(' ')
disp(' ')
disp('Tether catenary curve test:')
disp(' ')
tic
status = [status, Run_catenary_curve()];
toc
end
if all(status==1)
    disp(' ')
    disp(' ')
    disp('All tests successful!!!')
end