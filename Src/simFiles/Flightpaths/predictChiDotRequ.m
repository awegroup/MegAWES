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

function [chi_tau_dot] = predictChiDotRequ(long,lat,v_w_vec, pos_W,p_C_W, t, DtDs,chi_parallel )
% This function calculates the course rate in the tangential plane based
% on the path curvature
v_w_tau = transformFromWtoTau( long, lat, v_w_vec); 

ex = [-sin(lat)*cos(long);
    -sin(lat)*sin(long);
    cos(lat) ];

ey =  [-sin(long);
    cos(long);
    0];

% Derivative of ex_tau with respect to lambda
dexdlambda = [sin(lat)*sin(long);
    -sin(lat)*cos(long);
    0];

% Derivative of ex_tau with respect to phi
dexdphi = [-cos(lat)*cos(long);
    -cos(lat)*sin(long);
    -sin(lat)];

% Derivative of ey_tau with respect to lambda
deydlambda = [-cos(long); -sin(long); 0];

% Derivative of ey_tau with respect to phi
deydphi = zeros(3,1);

% Rate of longitude and latitude
lambda_dot = v_w_tau(2)/(cos(lat)*norm(pos_W));
phi_dot = v_w_tau(1)/norm(pos_W);

% Temporal derivative of ex_tau and ey_tau
dexdt = dexdphi * phi_dot + dexdlambda * lambda_dot;
deydt = deydphi * phi_dot + deydlambda * lambda_dot;

% Rotate the tangent and the tangent derivative to the path (parallel
% transport)
t_rot = doRodriguesRotation(pos_W, p_C_W, t);
DtDs_rot = doRodriguesRotation(pos_W, p_C_W, DtDs);
v_proj = (t_rot'* v_w_vec) / (t_rot'*t_rot*norm(pos_W) );

chi_tau_dot = 1/norm(t_rot)*...
    ((deydt'*t_rot+ey'*DtDs_rot*v_proj) * cos(chi_parallel) -...
     sin(chi_parallel) * (dexdt'*t_rot+ex'*DtDs_rot*v_proj));
 
end

