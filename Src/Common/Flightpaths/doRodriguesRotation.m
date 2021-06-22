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

function vrot = doRodriguesRotation(pos_W, p_target_W, v)
% This function performs the Rodrigues Rotation on a vector
%
% :param pos_W: Kite position, used to define plane of rotation
% :param p_target_W: Target position, used to define plane of rotation
% :param v: Vector to rotate
% :returns: 
%           - **vrot** - Rotated vector
%
% | Other m-files required: none
% | Subfunctions: none
% | MAT-files required: none
%
% :Version: 1.0
% :Author: Sebastian Rapp

theta = acos( max( min( pos_W'*p_target_W / norm(pos_W) / norm( p_target_W ), 1),-1) );
k = cross( p_target_W, pos_W );

if abs(theta) < 1e-12 || norm(k) < 1e-12
    vrot = v;
else
    k = k/norm(k);
    vrot = v*cos(theta)+cross(k,v)*sin(theta)+k * (k'*v)*(1-cos(theta));
end
end