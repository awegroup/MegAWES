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

function [act, base_windspeed, constr, DE2019, ENVMT, Lbooth, ...
        loiterStates, params, simInit, T, winchParameter] = ...
        Get_simulation_params(windspeed,Kite_DOF)
%Initialise simulation parameters for the complete system and set optimised parameters
%
% :param windspeed: Wind speed at which the parameters should be read
% :param Kite_DOF: Degrees of freedom of the kite (3 or 6)
%
% :returns:
%           - **act** - Actuator, aileron elevator and rudder data
%           - **base_windspeed** - Wind speed at max altitude where speed stays constant
%           - **constr** - Aircraft manoeuvre and winch constraints
%           - **ENVMT** - Environmental parameters
%           - **Lbooth** - Flight path parameters
%           - **loiterStates** - Initial loiter parameters (power cycle initialisation)
%           - **DE2019** - Aircraft parameters
%           - **simInit** - Simulation initialisation parameters
%           - **T** - Tether dimensions and material properties
%           - **winchParameter** - Winch dynamic parameters
%           - **params** - Flight/Winch controller parameters
%
% Example:
%       | [act, base_windspeed, constr, DE2019, ENVMT, Lbooth, ...
%       |             loiterStates, params, simInit, T, winchParameter] = ...
%       |             get_simulation_params(22, 6)
%
% | Other m-files required: initAllSimParams_DE2019.m
% | Subfunctions: None
% | MAT-files required: None
%
% :Revision: 17-March-2021
% :Author: Dylan Eijkelhof (d.eijkelhof@tudelft.nl)
 
%------------- BEGIN CODE --------------
    
    vw = windspeed;
    
    if Kite_DOF == 3
        % Point mass assumption
        [act, ~, constr, DE2019, ENVMT, Lbooth, ...
            loiterStates, params, simInit, T, winchParameter] = ...
            initAllSimParams_DE2019(Kite_DOF);
        base_windspeed = 22;
        if vw ~= 22
            warning('Maximum wind speed is forced to be 22 m/s at 250m altitude')
        end
		
        params.b_booth=353.551;
        params.l_tether_min=0.5121;
        params.initial_path_elevation=42.8742;
        params.w0_decrease_init_phi0=0.0891721;
        params.F_t_traction_set=1.54462e+06;
        params.F_t_retraction_set=0.396714;
        loiterStates.Ft_set_loiter=1.16544e+06;
        params.ft_smooth_2=0.1;
		params.Kp_chi_k_traction=0.92397;
		params.Kp_gamma_k_traction=3.29257;
		params.Kp_chi_retraction=4;
		params.Kp_gamma_retraction=0.8434;
		params.Kp_chi_loiter=4;
		params.Kp_mu=0.971239;
		params.Kp_alpha=0.2;
        params.kp_winch=1.14655;
		params.ki_winch=0.132527;
		params.Kp_brake=0.132448;
		params.Ki_brake=0;
        params.w0_chi_retraction_max=0.653226;
		params.w0_gamma_retraction_max=0.281603;
		params.w0_mu=7.6271;
		params.w0_alpha=3.56748;
 
    elseif Kite_DOF == 6
        % Initiate base (windspeed = 22)
        [act, ~, constr, DE2019, ENVMT, Lbooth, ...
            loiterStates, params, simInit, T, winchParameter] = ...
            initAllSimParams_DE2019(Kite_DOF);
        if vw == 8
            params.a_booth=1.19621;
            params.b_booth=330.043;
            params.l_tether_max=800;
            params.l_tether_min=0.4;
            params.w0_decrease_init_phi0  =0.107208;
            params.F_t_traction_set=795583;
            params.F_t_retraction_set=0.389683;
            loiterStates.Ft_set_loiter=998947;
            params.ft_smooth_2=0.001;
            params.Kp_chi_k_traction=0.7;
            params.Kp_gamma_k_traction =3;
            params.Kp_chi_retraction=0.4;
            params.Kp_gamma_retraction=0.97332;
            params.Kp_chi_loiter =2.44077;
            params.Kp_mu=0.198574;
            params.Kp_alpha=0.418098;
            params.Kp_p=15;
            params.Kp_q=15;
            params.Kp_r=6.2059;
            params.kp_winch=0.1;
            params.ki_winch=0.000921097;
            params.Kp_brake =0.33023;
            params.Ki_brake =0.979256;
            params.w0_chi_retraction_max=0.293705;
            params.w0_gamma_retraction_max=0.01;
            params.w0_p_max=5.68673;
            params.w0_q_max=5.76659;
            params.w0_r_max=1;
            params.arc1 =3.1;
        elseif vw == 10
            params.F_t_traction_set=332982;
            params.F_t_retraction_set=0.129398;
            params.ft_smooth_2=0.0927201;
            params.Kp_chi_k_traction=0.1;
            params.Kp_gamma_k_traction =2.19367;
            params.Kp_chi_retraction=0.297941;
            params.Kp_gamma_retraction=0.640821;
            params.Kp_alpha=0.2;
            params.Kp_p=0.1;
            params.Kp_q=6.93726;
            params.Kp_r=0.1;
            params.kp_winch=1.07825;
            params.Kp_brake =0.400744;
            params.Ki_brake =0;
            params.w0_gamma_retraction_max=0.434576;
            params.w0_p_max=6.24261;
            params.w0_q_max=5.39955;
            params.w0_r_max=1;
        elseif vw == 14
            params.a_booth=1.38794;
            params.w0_decrease_init_phi0  =0.005;
            params.F_t_traction_set=1.59831e+06;
            params.F_t_retraction_set=0.172843;
            params.ft_smooth_2=0.00307376;
            params.Kp_chi_k_traction=2.27749;
            params.Kp_gamma_k_traction =4;
            params.Kp_chi_retraction=0.005;
            params.Kp_gamma_retraction=0.105381;
            params.Kp_alpha=0.2;
            params.Kp_p=0.364097;
            params.Kp_q=9.09094;
            params.kp_winch=0.1;
            params.Kp_brake =0.0257332;
            params.Ki_brake =1.5;
            params.w0_p_max=15;
            params.w0_q_max=5.77144;
        elseif vw == 16
            params.a_booth=1.08241;
            params.b_booth=346.688;
            params.l_tether_min=0.4;
            params.w0_decrease_init_phi0  =0.0151422;
            params.F_t_traction_set=1.51317e+06;
            params.F_t_retraction_set=0.0922592;
            params.ft_smooth_2=0.1;
            params.Kp_chi_k_traction=0.865947;
            params.Kp_gamma_k_traction =1.29512;
            params.Kp_chi_retraction=0.005;
            params.Kp_gamma_retraction=0.005;
            params.Kp_mu=0.139372;
            params.Kp_alpha=0.635006;
            params.Kp_p=10;
            params.Kp_r=5.58439;
            params.kp_winch=0.295683;
            params.Kp_brake =0.01;
            params.Ki_brake =0.870709;
            params.w0_chi_retraction_max=0.306215;
            params.w0_p_max=12.2376;
            params.w0_q_max=4.56306;
            params.w0_r_max=11.9888;
            params.arc1 =2.07385;
        elseif vw == 18
            params.l_tether_min=0.605951;
            params.w0_decrease_init_phi0  =0.0423388;
            params.transition_phi =30.2495;
            params.F_t_traction_set=1.59831e+06;
            params.F_t_retraction_set=0.274943;
            params.ft_smooth_2=0.0900948;
            params.Kp_chi_k_traction=0.623031;
            params.Kp_gamma_k_traction =4;
            params.Kp_chi_retraction=0.669186;
            params.Kp_gamma_retraction=0.682898;
            params.Kp_mu=0.122912;
            params.Kp_alpha=0.956417;
            params.Kp_p=7.2182;
            params.Kp_r=0.1;
            params.kp_winch=0.49516;
            params.Kp_brake =0.01;
            params.Ki_brake =1.5;
            params.w0_chi_retraction_max=0.157853;
            params.w0_gamma_retraction_max=0.776615;
            params.w0_p_max=8.10721;
            params.w0_q_max=5.91244;
            params.w0_r_max=12.6844;
            params.arc1 =1.72582;
        elseif vw == 20
            params.b_booth=456.178;
            params.l_tether_min=0.630008;
            params.transition_phi =30.203;
            params.F_t_traction_set=1.36038e+06;
            params.F_t_retraction_set=0.336852;
            params.ft_smooth_2=0.0777781;
            params.Kp_chi_k_traction=0.794218;
            params.Kp_gamma_k_traction =0.909781;
            params.Kp_chi_retraction=0.707875;
            params.Kp_gamma_retraction=0.472609;
            params.Kp_alpha=0.702591;
            params.Kp_p=3.29734;
            params.Kp_q=4.14104;
            params.kp_winch=0.893688;
            params.Kp_brake =0.557553;
            params.Ki_brake =0.116862;
            params.w0_chi_retraction_max=0.110278;
            params.w0_gamma_retraction_max=0.743149;
            params.w0_p_max=9.32837;
            params.w0_q_max=6.16074;
            params.arc1 =2.24528;
            params.x_arcEnd =63.4549;
        elseif vw == 25
            params.a_booth=1.66286;
            params.phi0_booth =0.732933;
            params.l_tether_max=1264.56;
            params.initial_path_elevation =53.2887;
            params.w0_decrease_init_phi0  =0.0257363;
            params.F_t_traction_set=1.34767e+06;
            params.F_t_retraction_set=0.5;
            params.ft_smooth_2=0.00110343;
            params.Kp_chi_k_traction=0.1;
            params.Kp_gamma_k_traction =2.27624;
            params.Kp_chi_retraction=0.368819;
            params.Kp_gamma_retraction=1.78085;
            params.Kp_alpha=0.37568;
            params.Kp_p=10;
            params.Kp_r=5.53828;
            params.kp_winch=1.26635;
            params.Kp_brake =0.6;
            params.Ki_brake =0.0617754;
            params.w0_chi_retraction_max=0.24096;
            params.w0_gamma_retraction_max=0.709451;
            params.w0_p_max=8.4859;
            params.w0_q_max=7.0204;
            params.arc1 =1.05;
        elseif vw == 28
            params.phi0_booth =0.785398;
            params.l_tether_min=0.693607;
            params.initial_path_elevation =55;
            params.transition_phi =55;
            params.F_t_traction_set=1.25094e+06;
            params.F_t_retraction_set=0.5;
            params.ft_smooth_2=0.1;
            params.Kp_chi_k_traction=0.1;
            params.Kp_gamma_k_traction =2.63206;
            params.Kp_chi_retraction=0.728304;
            params.Kp_gamma_retraction=1.34774;
            params.Kp_alpha=0.531128;
            params.Kp_p=10;
            params.Kp_r=2.16183;
            params.kp_winch=1.51588;
            params.Kp_brake =0.28116;
            params.Ki_brake =0;
            params.w0_chi_retraction_max=0.349916;
            params.w0_p_max=9.41052;
            params.w0_q_max=4.74901;
        elseif vw == 30
            params.a_booth=2;
            params.phi0_booth =0.785398;
            params.initial_path_elevation =55;
            params.w0_decrease_init_phi0  =0.005;
            params.transition_phi =41.2721;
            params.F_t_traction_set=1.06315e+06;
            params.F_t_retraction_set=0.440517;
            params.ft_smooth_2=0.00834137;
            params.Kp_chi_k_traction=0.1;
            params.Kp_gamma_k_traction =3.02232;
            params.Kp_chi_retraction=0.498508;
            params.Kp_gamma_retraction=1.98229;
            params.Kp_alpha=0.763475;
            params.Kp_p=10;
            params.Kp_r=0.1;
            params.kp_winch=1.32928;
            params.Kp_brake =0.54958;
            params.Ki_brake =0.291639;
            params.w0_chi_retraction_max=0.500669;
            params.w0_gamma_retraction_max=0.864453;
            params.w0_p_max=8.64535;
            params.w0_q_max=6.70907;
            params.w0_r_max=6.90966;
            params.arc1 =1.73774;
        elseif vw ~= 22
            warning(['Controller parameters adopted from 22m/s wind, ',...
                'wind speed changed to ', num2str(vw) ,'m/s'])
        end
        base_windspeed = vw;
    else
        error('Wong number of degrees of freedom entered')
    end
%------------- END CODE --------------
end