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

function vec_Abar = transformFromO2Abar( chi_a, gamma_a, vec_O )

M_AbarO = [cos(chi_a)*cos(gamma_a), sin(chi_a)*cos(gamma_a), -sin(gamma_a); 
    -sin(chi_a), cos(chi_a), 0; 
    cos(chi_a)*sin(gamma_a), sin(chi_a)*sin(gamma_a), cos(gamma_a)];
vec_Abar = M_AbarO*vec_O; 