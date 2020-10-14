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

function vec_O = transformFromAbartoO( chi_a,gamma_a,  vec_Abar )

c_chia = cos(chi_a);
s_chia = sin(chi_a);

c_gama = cos(gamma_a);
s_gama = sin(gamma_a);

M_ABar2O = zeros(3,3);

M_ABar2O(1,1) = c_chia*c_gama;
M_ABar2O(2,1) = s_chia*c_gama;
M_ABar2O(3,1) = -s_gama;
M_ABar2O(1,2) = -s_chia;
M_ABar2O(2,2) = c_chia;
M_ABar2O(3,2) = 0;
M_ABar2O(1,3) = c_chia*s_gama;
M_ABar2O(2,3) = s_chia*s_gama;
M_ABar2O(3,3) = c_gama;

vec_O = M_ABar2O * vec_Abar; 