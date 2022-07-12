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

function [ sol,p_C_W] = getTargetOnBoothNewton2(Lem, p_kite_W, c0, l_tether, direction)
% This function calculates the closest point on the Lissajous figure from the kite position by means of newton iterations.
%
% :param Lem: Lissajous figure dimension parameter structure. 
% :param p_kite_W: Kite position in wind reference frame.
% :param c0: Old Lissajous path parameter s (0≤s≤2π).
% :param l_tether: Current tether length.
% :param direction: Flight direction on Lissajous.
% :returns: 
%           - **sol** - New Lissajous path parameter s (0≤s≤2π).
%           - **p_C_W** - Closest position on Lissajous figure in wind reference frame.
%
% | Other m-files required: doNewtonIterationBooth2.m
% | Subfunctions: none
% | MAT-files required: none
%
% :Version: 1.0
% :Author: Sebastian Rapp

p_kite_W = p_kite_W/norm(p_kite_W);

[sol, ~] = doNewtonIterationBooth2(c0,Lem, p_kite_W, direction);

long = Lem.b * sin(sol) ./( 1+(Lem.a/Lem.b*cos(sol)).^2 );
lat =   Lem.a * sin(sol).*cos(sol) ./ ( 1+(Lem.a/Lem.b*cos(sol)).^2 ) ;
L = [long;lat];
p_C_W = [cos(L(1,:)).*cos(L(2,:));
    sin(L(1,:)).*cos(L(2,:));
    sin(L(2,:))]*l_tether;


end