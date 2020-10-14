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

function Offline_visualisation_power(P_mech_last_cycle,Path_last_cycle)
%Offline_visualisation - Plot power curve and flight path
%
% Syntax:  Offline_visualisation(P_mech_last_cycle,Path_last_cycle)
%
% Inputs:
%    P_mech_last_cycle	- Converged cycle timeseries of power
%    Path_last_cycle	- Converged cycle timeseries of kite position
%
% Outputs:
%    output1 - None
%
% Example: 
%    Offline_visualisation(P_mech_last_cycle,Path_last_cycle);
%
% Other m-files required: enhance_plot.m
% Subfunctions: None
% MAT-files required: None
%
% Author: Dylan Eijkelhof, M.Sc.
% Delft University of Technology
% email address: d.eijkelhof@tudelft.nl  
% January 2020; Last revision: 01-September-2020

%------------- BEGIN CODE --------------
%% Power
figPO = figure(98);
Power = P_mech_last_cycle.Data./1e6;
PTime = P_mech_last_cycle.Time-P_mech_last_cycle.Time(1);
plot(PTime,Power,'b')
ylabel('Power [MW]')
xlabel('Cycle time [s]')
hold on; box on; grid on; axis tight;

plot([0 PTime(end)],[mean(Power) mean(Power)],'--')
plot([0 PTime(end)],[max(Power) max(Power)],'--')
enhance_plot('times',16,1.5,3,3)
legend('Power', 'Average power','Peak power','Location','best')
%     saveas(figPO,'power_cycle','epsc')

%% Flight path & power
fig_pow = figure(99);
set(gcf, 'Position',  [100, 100, 1400, 1000])
axes1 = axes('Parent',fig_pow,'Position',[0.13,0.11,0.678584552871244,0.815]);
hold(axes1,'on');
fig_pow.Renderer = 'painters';
view([27 39])
% set(gca,'XColor', 'none','YColor','none','ZColor','none')
% set(gcf, 'color', 'white');
% set(gca, 'color', 'white');

% Flight path coloured by power
sizeScatter = 5;
Power = P_mech_last_cycle.Data./1e6;
scatter3(-Path_last_cycle.Data(1,:),Path_last_cycle.Data(2,:),-Path_last_cycle.Data(3,:),sizeScatter*ones(size(Power)),Power,'filled'); hold on
enhance_plot('Helvetica',25,2,20,0)

%Colorbar
LimitsColorBar = [floor(min(Power)/1)*1 ceil(max(Power)/1)*1];
cb = colorbar('peer',axes1,'Location','eastoutside','FontSize',16);
cb.Label.String = 'Power, MW';
caxis(LimitsColorBar)
cb.FontSize = 16;
cb.Location = 'eastoutside';
cb.Position = [0.874536933823625,0.111493416432584,0.010666666666667,0.815];   
cb.Label.FontSize = 16;

% Graph limits
limitz = [0 1000];
limity = [-600 600];
limitx = [-100 1500];
zlim(limitz)
ylim(limity)
xlim(limitx)
xlabel('x_W [m]','FontSize',25);
ylabel('y_W [m]','FontSize',25);
zlabel('z_W [m]','FontSize',25);
grid off

X = [limitx(1);limitx(2);limitx(2);limitx(1)];
Y = [limity(1);limity(1);limity(2);limity(2)];
Z = [limitz(1);limitz(1);limitz(1);limitz(1)];
c = [0 1 0; 
0 1 0; 
0 1 0;
0 1 0];
fill3(X,Y,Z, c(:,2),'EdgeColor','none','FaceColor',c(1,:),'FaceAlpha',0.1);

X = [limitx(1);limitx(1);limitx(1);limitx(1)];
Y = [limity(1);limity(1);limity(2);limity(2)];
Z = [limitz(1);limitz(2);limitz(2);limitz(1)];
c = [200/255 200/255 200/255;
0 0 0;
0 0 0;
0 0 0];
fill3(X,Y,Z, c(:,2),'EdgeColor','none','FaceColor',c(1,:),'FaceAlpha',0.1);

X = [limitx(1);limitx(2);limitx(2);limitx(1)];
Y = [limity(2);limity(2);limity(2);limity(2)];
Z = [limitz(1);limitz(1);limitz(2);limitz(2)];
fill3(X,Y,Z, c(:,2),'EdgeColor','none','FaceColor',c(1,:),'FaceAlpha',0.1);

%Path projections on sides/walls of the graph
h(1) = scatter3(-Path_last_cycle.Data(1,:),Path_last_cycle.Data(2,:),zeros(size(-Path_last_cycle.Data(3,:))));
enhance_plot('Helvetica',25,2,20,0)
h(2) = scatter3(-Path_last_cycle.Data(1,:),zeros(size(Path_last_cycle.Data(2,:)))+limity(2),-Path_last_cycle.Data(3,:));
enhance_plot('Helvetica',25,2,20,0)
set(h,'MarkerFaceColor',[0.4 0.4 0.4],'MarkerEdgeColor','none','SizeData',.5,'LineWidth',0.01);
%------------- END CODE --------------
end

