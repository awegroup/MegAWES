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

function vec_B = transformFromAbar2B( mu_a, alpha, beta,  vec_Abar )
% This function transforms a vector between rotated aerodynamic reference frame and body reference frame.
%
% :param mu_a: Roll angle.
% :param alpha: Pitch angle (Angle of Attack).
% :param beta: Yaw angle.
% :param vec_Abar: Vector in rotated aerodynamic reference frame.
% :returns: 
%           - **vec_B** - Vector in body reference frame.
%
% | Other m-files required: none
% | Subfunctions: none
% | MAT-files required: none
%
% :Version: 1.0
% :Author: Sebastian Rapp

c_m = cos(mu_a);
s_m = sin(mu_a);

c_a = cos(alpha);
s_a = sin(alpha);

c_b = cos(beta);
s_b = sin(beta);

M_ABar2B = zeros(3,3);

M_ABar2B(1,1) = c_a*c_b;
M_ABar2B(2,1) = s_b;
M_ABar2B(3,1) = s_a*c_b;
M_ABar2B(1,2) = -c_a*s_b*c_m+s_a*s_m;
M_ABar2B(2,2) = c_b*c_m;
M_ABar2B(3,2) = -s_a*s_b*c_m-s_m*c_a;
M_ABar2B(1,3) = -c_a*s_b*s_m-s_a*c_m;
M_ABar2B(2,3) = c_b*s_m;
M_ABar2B(3,3) = -s_a*s_b*s_m+c_a*c_m;

vec_B = M_ABar2B * vec_Abar; 