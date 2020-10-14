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

function vec_Abar = transformFromOtoAbar( chi_a,gamma_a,  vec_O )

c_chia = cos(chi_a);
s_chia = sin(chi_a);

c_gama = cos(gamma_a);
s_gama = sin(gamma_a);

M_O2ABar = zeros(3,3);

M_O2ABar(1,1) = c_chia*c_gama;
M_O2ABar(1,2) = s_chia*c_gama;
M_O2ABar(1,3) = -s_gama;
M_O2ABar(2,1) = -s_chia;
M_O2ABar(2,2) = c_chia;
M_O2ABar(2,3) = 0;
M_O2ABar(3,1) = c_chia*s_gama;
M_O2ABar(3,2) = s_chia*s_gama;
M_O2ABar(3,3) = c_gama;

vec_Abar = M_O2ABar * vec_O; 