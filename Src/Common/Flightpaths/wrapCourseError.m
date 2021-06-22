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

function e_course = wrapCourseError(chi_ref, chi)
% Wrapping of course angle error
%
% The vectors are laying in the tangential plane attached to the current position on the small earth.
%
% | Other m-files required: none
% | Subfunctions: none
% | MAT-files required: none
%
% :Version: 1.0
% :Author: Sebastian Rapp

p_bearing_vec =   [cos(chi);         sin(chi);         0];
ref_bearing_vec = [cos(chi_ref); sin(chi_ref); 0];

e_z = cross( ref_bearing_vec, p_bearing_vec ); 

dot_product = dot( ref_bearing_vec, p_bearing_vec ); 
if dot_product > 1 
    dot_product = 1; 
end
if dot_product < -1 
    dot_product = -1; 
end
e_course = - sign( e_z(3) ) * acos( dot_product );
end
