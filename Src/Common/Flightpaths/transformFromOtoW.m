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

function [vec_W] = transformFromOtoW(windDirection_rad,vec_O)
% This function transforms a vector between inertial reference frame and wind reference frame.
%
% :param windDirection_rad: Angle between the wind reference frame and the inertial reference frame around the z-axis.
% :param vec_O: Vector in inertial reference frame.
% :returns: 
%           - **vec_W** - Vector in wind reference frame.
%
% | Other m-files required: none
% | Subfunctions: none
% | MAT-files required: none
%
% :Version: 1.0
% :Author: Sebastian Rapp
%
% .. note:: Axis system is not only rotated around the z-axis but also also flipped upside down. :math:`Z_W = -Z_O`.

M_WO = [cos(windDirection_rad), sin(windDirection_rad), 0;
        sin(windDirection_rad), -cos(windDirection_rad), 0;
        0, 0, -1];

vec_W = M_WO*vec_O;

end
