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

function vec_tau = transformFromWtoTau(  lamb,phi, vec_W )

M_tauW = [-sin(phi)*cos(lamb), -sin(phi)*sin(lamb), cos(phi);
    -sin(lamb), cos(lamb), 0;
    -cos(phi)*cos(lamb), -cos(phi)*sin(lamb), -sin(phi)];

vec_tau = M_tauW * vec_W; 