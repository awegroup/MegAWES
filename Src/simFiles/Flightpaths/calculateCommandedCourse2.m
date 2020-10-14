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

function [Chi_cmd,Delta_chi,theta, Delta_chi_dot, deltaDot1] = calculateCommandedCourse2(t,delta_vec, delta, delta0, chi_parallel, L_sol, pos_W, v_w_vec, chi_tau_is)

% check sign with curve frame - y component is negative in this frame -
% delta Chi is positive and vice versa.
% add a predictive part to smooth highly curved paths.
% basis:
e1 = t/norm(t);
e3 = -L_sol/norm(L_sol);
e2 = cross(e3, e1);
M_CW = [e1';e2';e3'];
pos_C = M_CW * (pos_W-L_sol);


Delta_chi = atan2( -sign(pos_C(2)) * delta, delta0 );
% Delta_chi = asin( -sign(pos_C(2))*max( min( delta*delta0, 1), -1) ); 
1;


Chi_cmd = chi_parallel + Delta_chi;

if Chi_cmd > pi
    Chi_cmd = -pi + mod( Chi_cmd, pi );
elseif Chi_cmd < -pi
    Chi_cmd = pi + mod(Chi_cmd, -pi);
end

if sign(pos_C(2)) < 0
    theta = pi/2 - Delta_chi;
else
    theta = pi/2 + Delta_chi;
end
if delta < 1e-6 
    Delta_chi_dot = 0; 
    deltaDot1 = 0; 
else  
    %Delta_chi_dot = sign(pos_C(2)) * norm(v_w_vec/norm(pos_W)) / delta0^2 * delta/(1+(delta/delta0)^2)^(3/2);
    %deltaDot1 = sign(pos_C(2)) * norm(v_w_vec/norm(pos_W)) * sin(Delta_chi);
    %deltaDot1 =  (-v_w_vec'/norm(pos_W) * delta_vec );
    e_chi = wrapCourseError( Chi_cmd, chi_tau_is);
    deltaDot1 = -norm( v_w_vec'/norm(pos_W) ) * sign(pos_C(2)) * sin( -Delta_chi + e_chi )  ;
    Delta_chi_dot = -sign(pos_C(2)) / delta0 / (1+(delta/delta0)^2) * deltaDot1; 
end

end

