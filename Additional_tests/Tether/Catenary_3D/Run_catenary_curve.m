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

function status = Run_catenary_curve()
%Run_catenary_curve - Tether test case: catenary curve in 3D environment
% Cable hanging between 2 points in 3D at different altitudes
%
% Inputs:
%    None
%
% Outputs:
%    status         - Passed (1) or failed (0)
%
% Other m-files required: initAllSimParams_DE2019.m
%                         initAllSimParams_catenary.m
%                         distance2curve.m
% Subfunctions: none
% MAT-files required: none
%
% Syntax:  status = Run_catenary_curve()
%
% Author: Dylan Eijkelhof, M.Sc.
% Delft University of Technology
% email address: d.eijkelhof@tudelft.nl  
% March 2021; Last revision: 17-March-2021

%------------- BEGIN CODE --------------

%% Set Variables
[act, base_windspeed, constr, DE2019, ENVMT, Lbooth, ...
    loiterStates, params, simInit, T, winchParameter] = initAllSimParams_DE2019(6);

[simInit, T] = initAllSimParams_catenary(ENVMT, simInit, T); %#ok<*ASGLU>

%% Run Sim
simOut = sim('tether_catenary_R2019B.slx', 'SrcWorkspace', 'current');

%% Test Criteria
%Plot result
% plot3( [0;flipud(Tether_x.Data(:,end));simInit.pos_W_init(1)], [0;flipud(Tether_y.Data(:,end));simInit.pos_W_init(2)],[0;flipud(Tether_z.Data(:,end));simInit.pos_W_init(3)] , '-', 'color', [0.1 0.1 0.1], 'Markersize',2, 'Linewidth', 1.2, 'MarkerFaceColor', [0.3 0.3 0.3]); hold on;
% plot3(simInit.x_catenary, simInit.y_catenary, simInit.z_catenary,'-o')

xy = zeros(1,numel(simOut.Tether_x.Data(:,end)));
for i = 1:numel(simOut.Tether_x.Data(:,end))
    xy(1,i) = norm([simOut.Tether_x.Data(i,end),simOut.Tether_y.Data(i,end)]);
end

y_catenary = zeros(numel(simInit.x_catenary),1);
for i = 1:numel(simInit.x_catenary)
    y_catenary(i,1) = norm([simInit.x_catenary(i),simInit.y_catenary(i)]);
end

[~,distance,~] = distance2curve([y_catenary simInit.z_catenary'],[xy' simOut.Tether_z.Data(:,end)]);

average_error = sum(distance)/numel(distance);

if average_error <= T.tether_inital_lenght*0.01 %1% of tether length
    disp(' ')
    disp('Success')
    disp('---------- Tether seems to follow the analytical catenary curve -------------')
    disp('---------- Plot to see the result -------------')
    status = 1;
else
    disp(' ')
    disp('Failed')
    status = 0;
end
%------------- END CODE --------------
end