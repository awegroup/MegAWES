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

function point_W = getPointOnBooth( a, b, phi, l_tether, s )

Lbooth.b = b;
Lbooth.a =b*a;
Lbooth.phi0 = phi;
[Lem] = updateBoothLemniscate(l_tether,Lbooth);

long_P = Lem.b * sin(s) ./( 1+(Lem.a/Lem.b*cos(s)).^2 );
lat_P =   Lem.a * sin(s).*cos(s) ./ ( 1+(Lem.a/Lem.b*cos(s)).^2 );

p_P = [ cos(long_P).*cos(lat_P);sin(long_P).*cos(lat_P);sin(lat_P)]*l_tether;

phi_p_mean = phi;  
M_WP = [cos(phi_p_mean),0, -sin(phi_p_mean);0, 1, 0;  sin(phi_p_mean),0, cos(phi_p_mean)];  
 
point_W = M_WP * p_P; 


end