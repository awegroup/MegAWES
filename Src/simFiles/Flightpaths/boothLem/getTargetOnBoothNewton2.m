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

function [ sol,p_C_W] = getTargetOnBoothNewton2(Lem, p_kite_W, c0, l_tether, direction)

p_kite_W = p_kite_W/norm(p_kite_W);

[sol, ~] = doNewtonIterationBooth2(c0,Lem, p_kite_W, direction);

sol = sol + direction*0*pi/180;

long = Lem.b * sin(sol) ./( 1+(Lem.a/Lem.b*cos(sol)).^2 );
lat =   Lem.a * sin(sol).*cos(sol) ./ ( 1+(Lem.a/Lem.b*cos(sol)).^2 ) ;
L = [long;lat];
p_C_W = [cos(L(1,:)).*cos(L(2,:));
    sin(L(1,:)).*cos(L(2,:));
    sin(L(2,:))]*l_tether;


end