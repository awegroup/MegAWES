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

function vec_W = transformFromTautoW( long,lat,  vec_tau )
% This function transforms a vector in the tangential plane to the wind reference frame.
%
% :param long: Longtitude position of the kite.
% :param lat: Latitude position of the kite.
% :param vec_tau: Vector in the tangential plane.
% :returns: 
%           - **vec_W** - Vector in wind reference frame.
%
% | Other m-files required: none
% | Subfunctions: none
% | MAT-files required: none
%
% :Version: 1.0
% :Author: Sebastian Rapp

M_Wtau = [-sin(lat)*cos(long),-sin(long),-cos(lat)*cos(long);
    -sin(lat)*sin(long), cos(long), -cos(lat)*sin(long);
    cos(lat), 0, -sin(lat)];


vec_W = M_Wtau * vec_tau; 