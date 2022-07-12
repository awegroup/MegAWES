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

function [s_new,exceedMaxIter] = doNewtonIterationBooth2(s_old,Lem, pos_W, direction)
% This function performs a newton iteration to find the closest point on the Lissajous figure from the kite position.
%
% :param s_old: Old Lissajous path parameter s (0≤s≤2π)
% :param Lem: Lissajous figure dimension parameter structure. 
% :param pos_W: Position of the kite in wind reference frame.
% :param direction: Flight direction on Lissajous.
% :returns: 
%           - **s_new** - New Lissajous path parameter s (0≤s≤2π).
%           - **exceedMaxIter** - Returns 1 when maximum number of iterations (10) is exceeded.
%
% | Other m-files required: getBoothInfos2.m
% | Subfunctions: none
% | MAT-files required: none
%
% :Version: 1.0
% :Author: Sebastian Rapp

pos_W = pos_W/norm(pos_W); 
res = 1;
cnt = 1; 
maxIter = 10; 
s_new = s_old;

while (res > 0.1*pi/180 && cnt < maxIter)
    [t,DtDs,~, ~,~] = getBoothInfos2(s_old,Lem, direction);    
    deltaDs =  pos_W'*t ; 
    deltaD2s = pos_W'*DtDs; 

    s_new = s_old - direction * deltaDs/deltaD2s; % Note: We have to take into account the sign of the tangent
    % for the Minim. the direction of flight does not matter, we changed
    % however the sign according to it, hence we have to adapt it here again.

    s_new = mod(s_new, 2*pi);
    res = abs( s_new - s_old ); 
    s_old = s_new;

    cnt = cnt + 1 ;
end

if cnt > maxIter 
    exceedMaxIter = 1; 
else
    exceedMaxIter = 0;
end

