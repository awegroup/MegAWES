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

function [t,DtDs,L, dLds,q] = getBoothInfos2(s_old,Lbooth, direction)
% Calculate the tangent at path position s_old and its derivative.
%
% :param s_old: Old Lissajous path parameter s (0≤s≤2π)
% :param Lbooth: Lissajous figure dimension parameter structure. 
% :param direction: Flight direction on Lissajous.
% :returns: 
%           - **t** - Tangent.
%           - **DtDs** - Derivative of the tangent with respect to the position on the Lissajous figure.
%           - **L** - Lemniscate of Booth
%           - **dLds** - Derivative of the Lemniscate with respect to the position on the Lissajous figure.
%           - **q** - Path in cartesian coordinates in the wind reference frame.
%
% | Other m-files required: none
% | Subfunctions: none
% | MAT-files required: none
%
% :Version: 1.0
% :Author: Sebastian Rapp

a = Lbooth.a; 
b = Lbooth.b;
L = [ b * sin(s_old) ./( 1+(a/b*cos(s_old)).^2 );
    a * sin(s_old).*cos(s_old) ./ ( 1+(a/b*cos(s_old)).^2 ) ] ;

dLds = [ ( b^3*cos(s_old).*(2*a^2-a^2*cos(s_old).^2+b^2)./(a^2*cos(s_old).^2+b^2).^2 );
    ( (cos(s_old).^2*(a^3*b^2+2*a*b^4) - a*b^4)./(a^2*cos(s_old).^2+b^2).^2 )];  

d2Lds2 =  [ ( -( (a^4*b^3*sin(s_old).^5-b^3*sin(s_old).*(5*a^4+4*(a*b)^2-b^4)+b^3*sin(s_old).^3 *(4*a^4+6*(a*b)^2 ))./(b^2-a^2*(sin(s_old).^2 - 1 ) ).^3 ) );
            ( (2*a*b^2*cos(s_old).^3.*sin(s_old)*(a^4+2*(a*b)^2)-a*b^2*cos(s_old).*sin(s_old)*(3*(a*b)^2+2*b^4)*2)./(a^2*cos(s_old).^2 + b^2 ).^3 )];


s_lambda = sin( L(1,:)  ); 
s_phi = sin( L(2,:) );
c_lambda = cos( L(1,:) ); 
c_phi = cos( L(2,:) ); 

q = [c_lambda*c_phi; s_lambda*c_phi; s_phi];

dqdlambda = [-s_lambda*c_phi; c_lambda*c_phi; 0];
dqdphi = [-c_lambda*s_phi; -s_lambda*s_phi; c_phi];

t = direction*( dqdlambda * dLds(1) + dqdphi *dLds(2) ); 

dtdlambda = [-c_lambda*c_phi*dLds(1)+s_lambda*s_phi*dLds(2); 
             -s_lambda*c_phi*dLds(1)-s_phi*c_lambda*dLds(2);
            0];
        
dtdphi = [s_lambda*s_phi*dLds(1)-c_phi*c_lambda*dLds(2); 
         -c_lambda*s_phi*dLds(1)-c_phi*s_lambda*dLds(2); 
         -s_phi*dLds(2)];
     
dtds = dqdlambda * d2Lds2(1)  + dqdphi * d2Lds2(2); 
     
% The negative sign cancels out 
DtDs =  ( dtdlambda * dLds(1) + dtdphi * dLds(2) + dtds ); 



end

