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

function [chi_dot, gamma_dot] = getChiDotGammaDotOK(windDirection_rad,lat,long, v_k_W, chi_tau_dot, r, chi_k, gamma_k, v_ideal, pos_W, gamma_tau,gamma_tau_dot)

v_k_W  = v_k_W / norm(pos_W); 

v_k_O = transformFromWtoO(windDirection_rad, v_k_W); 
ex = v_k_O/norm(v_k_O); 
pos_O = transformFromWtoO(windDirection_rad, pos_W); 
ez_tmp = -pos_O/norm(pos_O);
ey = cross(ez_tmp, ex); ey = ey/norm(ey);
ez = cross(ex, ey);

M_KbarO = [ex';ey';ez'];    
M_OKbar = M_KbarO'; 

omega_OKbar_Kbar = [-chi_tau_dot*sin(gamma_tau);
                     gamma_tau_dot;
                     chi_tau_dot*cos(gamma_tau)];

v_k_tau = transformFromWtoTau( long, lat, v_ideal); 

long_dot = v_k_tau(2) /(r*cos(lat)); 
lat_dot = v_k_tau(1) / r; 
  
omega_WT_W = [lat_dot*sin(long); 
             -lat_dot*cos(long); 
              long_dot];

omega_WT_O = transformFromWtoO(windDirection_rad, omega_WT_W ); 

omega_OT_O = omega_WT_O; 

omega_OKbar_O = omega_OT_O + M_OKbar * omega_OKbar_Kbar; 
omega_OKbar_Kbar = M_KbarO * omega_OT_O + omega_OKbar_Kbar;

gamma_dot = omega_OKbar_O(1) * (-sin(chi_k)) + omega_OKbar_O(2) * cos(chi_k); 
mu = atan2( M_OKbar(3,2),M_OKbar(3,3) ); 
chi_dot = (omega_OKbar_Kbar(2) * sin(mu) + omega_OKbar_Kbar(3) * cos(mu) ) / cos(gamma_k); 
end



