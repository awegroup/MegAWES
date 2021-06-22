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

function status = Run_tether_fall2()
%Run_tether_fall2 - Tether test case: Test whether tether falls at
%                   gravitational constant (gravity only) 
%
% Inputs:
%    None
%
% Outputs:
%    status         - Passed (1) or failed (0)
%
% Other m-files required: initAllSimParams_DE2019.m
%                         initAllSimParams_tether_fall2.m
% Subfunctions: none
% MAT-files required: none
%
% Syntax:  status = Run_tether_fall2()
%
% Author: Dylan Eijkelhof, M.Sc.
% Delft University of Technology
% email address: d.eijkelhof@tudelft.nl  
% March 2021; Last revision: 17-March-2021

%------------- BEGIN CODE --------------

%% Set Variables
[act, base_windspeed, constr, DE2019, ENVMT, Lbooth, ...
    loiterStates, params, simInit, T, winchParameter] = initAllSimParams_DE2019(6);

[simInit, T] = initAllSimParams_tether_fall2(ENVMT, simInit, T); %#ok<*ASGLU>

%% Run test and print result

simOut = sim('tether_fall2_R2019B.slx', 'SrcWorkspace', 'current');

if simOut.acc_kite.Data(end) <= -ENVMT.g*0.99 && simOut.acc_kite.Data(end) >= -ENVMT.g*1.01
    disp(' ')
    disp('Success')
    disp('---------- Kite falls within 1% of gravitational accelleration -------------')
    status = 1;
else
    disp(' ')
    disp('Failed')
    status = 0;
end

if simOut.acc_kite.Time(end) >= simInit.TSIM
    disp(' ')
    disp('!!! Simulation time exceeded, consider re-running with larger simInit.TSIM !!!')
    status = 0;
end
%------------- END CODE --------------
end