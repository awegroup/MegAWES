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

function fig_PO = Theoretical_Pcheck(simOut,constr,ENVMT,DE2019,simInit,T,params,fig_PO)
% Theoretical check, add values to instantaneous power plot.
%
% :param simOut: Simulation output
% :param constr: Aircraft manoeuvre and winch constraints
% :param ENVMT: Environmental parameters
% :param DE2019: Aircraft parameters
% :param simInit: Simulation initialisation parameters
% :param T: Tether dimensions and material properties
% :param params: Flight/Winch controller parameters
% :param fig_PO: Instantaneous power figure (Offline_visualisation_power.m)
% :returns: 
%           - **fig_PO** - Instantaneous power plot of converged power cycle with theoretical power.
%
% | Other m-files required: Offline_visualisation_power.m(if fig_PO not given), extractSignalOfLastCycle_nD.m
% | Subfunctions: none
% | MAT-files required: none
%
% :Revision: 14-April-2021
% :Author: Dylan Eijkelhof (d.eijkelhof@tudelft.nl)
%
% .. note::
%           - Loyd peak power with cosine losses from cycle CL and CD, 
%           - Costello et al. average power from cycle CL and CD

%------------- BEGIN CODE --------------
if nargin<8
    fig_PO = NaN;
end

if ~simOut.power_conv_flag
    error('Simulation output does not contain a converged result')
end

%% Calculate parameters needed to fill in the theoretical equation of Loyd
colourvec = {'#77AC30', '#A2142F', '#EDB120', '#0072BD', 'm', 'c', 'y'};
TL = extractSignalOfLastCycle_nD(simOut.tether_length, ...
            simOut.cycle_signal_counter, simInit );
Vw = extractSignalOfLastCycle_nD(simOut.v_w, ...
        simOut.cycle_signal_counter, simInit );
Flightstate_last_cycle = extractSignalOfLastCycle_nD(simOut.sub_flight_state, ...
        simOut.cycle_signal_counter, simInit);
Alpha_last_cycle = extractSignalOfLastCycle_nD(simOut.alpha, ...
        simOut.cycle_signal_counter, simInit);
% Lift_last_cycle = extractSignalOfLastCycle_nD(simOut.lift, ...
%         simOut.cycle_signal_counter, simInit);
Drag_last_cycle = extractSignalOfLastCycle_nD(simOut.drag, ...
        simOut.cycle_signal_counter, simInit);
Faero_last_cycle = extractSignalOfLastCycle_nD(simOut.Faero, ...
        simOut.cycle_signal_counter, simInit);
P_mech_last_cycle = extractSignalOfLastCycle_nD(simOut.P_mech, ...
        simOut.cycle_signal_counter, simInit);
dp_retract = find((Flightstate_last_cycle.Data==6|Flightstate_last_cycle.Data==7),1);
t_retract = Flightstate_last_cycle.Time(dp_retract);    

amin = rad2deg(constr.alpha_a_min);
amax = rad2deg(constr.alpha_a_max);
ind = (DE2019.initAircraft.alpha>=amin & DE2019.initAircraft.alpha<=amax);
x = DE2019.initAircraft.alpha(ind);
y1 = DE2019.initAircraft.wing_cL_Static(ind);
y2 = DE2019.initAircraft.wing_cD_Static(ind);
alpha_list = rad2deg(Alpha_last_cycle.Data(Alpha_last_cycle.Time<=t_retract));
alpha_list(alpha_list>amax) = amax;
alpha_list(alpha_list<amin) = amin;
C_L = interp1(x,y1,alpha_list);
C_D = interp1(x,y2,alpha_list);
C_D_tether = T.CD_tether*TL.Data(TL.Time<=t_retract)*T.d_tether/(4*DE2019.S_wing);
         
[cl3cd2,itether] = max(C_L.^3./(C_D+C_D_tether).^2);

% Just reel-out phase is taken into account as this is where peak power is
% expected to occur.
p_loyd_tether = 2/27*ENVMT.rhos*DE2019.S_wing*mean(Vw.Data)^3*cl3cd2*cos(params.phi0_booth)^3/1e6;

disp(['CL @ CDeff: ', num2str(C_L(itether))])
disp(['CDeff: ', num2str(C_D(itether)+C_D_tether(itether))])
tltest = TL.Data(TL.Time<=t_retract);
disp(['Tether length: ', num2str(tltest(itether))])
disp(['Peak power (reel-out): ', num2str(p_loyd_tether), ' MW'])
Pw = 0.5*ENVMT.rhos*mean(Vw.Data)^3;
disp(['Power density: ', num2str(Pw)])

%% Costello et al.
% Lift = Lift_last_cycle.Data(Lift_last_cycle.Time<=t_retract);
Drag = mean(Drag_last_cycle.Data(Drag_last_cycle.Time<=t_retract));
Faero = mean(Faero_last_cycle.Data(Faero_last_cycle.Time<=t_retract));
e = (cos(params.phi0_booth+asin(...
    (Drag/Faero)*sin(params.phi0_booth)+...
    (DE2019.mass*ENVMT.g/Faero)*cos(params.phi0_booth)))^3);
zeta = 4/27*mean(C_L.^3./(C_D+C_D_tether).^2);
Costello_Pavg_max = e*Pw*DE2019.S_wing*zeta/1e6;
disp(['Costello Pavg max. (reel-out): ', num2str(Costello_Pavg_max), ' MW'])
% Pout = mean([P_mech_last_cycle.Data(1:dp_retract-1);0.*P_mech_last_cycle.Data(dp_retract:end)]);

disp(['zeta: ', num2str(zeta)])
disp(['e: ', num2str(e)])

%% Plotting
if ishandle(fig_PO)
    figure(fig_PO)
    legend('Interpreter', 'latex')
    
    if p_loyd_tether < 1
        mp = [num2str(p_loyd_tether*1e3,3) ' kW'];
    else
        mp = [num2str(p_loyd_tether,3) ' MW'];
    end
    plot([0, Vw.Time(end)-Vw.Time(1)],[p_loyd_tether,p_loyd_tether],'-.','Color',colourvec{4},'DisplayName',['$P_{max}$ (' mp ')'])
    
    if Costello_Pavg_max < 1
        mpc = [num2str(Costello_Pavg_max*1e3,3) ' kW'];
    else
        mpc = [num2str(Costello_Pavg_max,3) ' MW'];
    end
    plot([0, Vw.Time(end)-Vw.Time(1)],[Costello_Pavg_max,Costello_Pavg_max],'-.','Color',colourvec{5},'DisplayName',['$\tilde{P}$ (' mpc ')'])
    
    ylim([min(P_mech_last_cycle.Data./1e6), ceil(max([P_mech_last_cycle.Data./1e6;p_loyd_tether;Costello_Pavg_max]))])
    
end
end