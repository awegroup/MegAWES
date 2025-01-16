% Demonstration Script: Visualization and Analysis of 3D Simulation Results
%
% This script demonstrates how to visualize and analyze simulation results 
% for a kite system. It provides examples of plotting the 3D trajectory 
% of the kite, coloring it by mechanical power, and analyzing power 
% production over time. The script also highlights how to compute and 
% display the projected ground area of the trajectory.
%
% Steps:
%   1. Add required directories (`Lib`, `Src`) to the MATLAB path.
%   2. Extract mechanical power and kite position signals from the last 
%       pumping cycle before convergence.
%   3. Visualize the kite's 3D trajectory with mechanical power as the 
%       color scale.
%   4. Compute and display the ground projection area of the trajectory.
%   5. Plot mechanical power over time, including positive/negative power 
%    contributions and the mean power.
%
% Key Functions:
%   - extractSignalOfLastCycle2: Extracts the mechanical power signal from the last cycle.
%   - extractSignalOfLastCycle3D: Extracts the 3D kite position signal from the last cycle.
%
% Outputs:
%   - A 3D scatter plot of the trajectory with power-based coloring.
%   - A ground projection rectangle overlaid on the trajectory.
%   - A time-series graph of mechanical power, showing positive and negative 
%   contributions and the mean power.
%
% Usage:
%   This script is intended as a demonstration of how to process and visualize 
%   simulation results. It assumes that the required simulation outputs 
%   (`simOut`, `simInit`) and helper functions are available in the MATLAB 
%   workspace.
%
% Author:
%   Dylan Eijkelhof (d.eijkelhof@tudelft.nl)
%
% Date:
%   2025-01-15

clc
close all

addpath(genpath('Lib'))
addpath(genpath('Src'))

%% 3D simulation plot results - Trajectory coloured by Mechanical Power

% Extract mechanical power from last pumping cycle before converegence
P_mech = extractSignalOfLastCycle2(simOut.P_mech, ...
                simOut.cycle_signal_counter, simInit );

% Extract 3D kite position from last pumping cycle before converegence
KitePosW = extractSignalOfLastCycle3D(simOut.kiteposW, ...
                simOut.cycle_signal_counter, simInit );


%Define color of trajectory based on power produced
color_values =  P_mech.Data;

% Define trajectory coordinates in WindrefFrame
x = KitePosW.Data(:,1);
y = KitePosW.Data(:,2);
z = KitePosW.Data(:,3);

% Plot the trajectory 
fig1 = figure;
scatter3(x, y, z, 20, color_values, 'filled');
colormap('jet');
colorbar;

% Define projected ground area of trajectory
x_min = min(x);
x_max = max(x);
y_min = min(y);
y_max = max(y);

width = x_max - x_min;
height = y_max - y_min;
area = width * height; % Calculate the area of the rectangle

% Computes the coordinate of the vertices
rectangle_x = [x_min, x_max, x_max, x_min];
rectangle_y = [y_min, y_min, y_max, y_max];
rectangle_z = [0, 0, 0, 0]; 

% Plot the trajectory boundaries
patch(rectangle_x, rectangle_y, rectangle_z, 'EdgeColor', 'r', 'FaceAlpha', 0, 'LineStyle', '--');
vertices = [-250 -800 0; -250 800 0; 1500 800 0; 1500 -800 0];
faces = [1 2 3 4];
patch('Vertices', vertices, 'Faces', faces, 'FaceColor', 'g', 'FaceAlpha', 0.1);

% Set the desired plot settings
azimuth = 31;     % Example azimuth angle (horizontal rotation)
elevation = 28;   % Example elevation angle (vertical rotation)
view(azimuth, elevation);

axis equal;
daspect([1, 1, 1]);

xlim([-250, 1300]);  % Limit x
ylim([-800, 800]);  % Limit y
zlim([0, 1200]);

ylabel(colorbar, 'Mechanical Power [MW ]'); %x 10^1
xlabel('X_w [m]');
ylabel('Y_w [m]');
zlabel('Z_w [m]');

%% Plot Mechanical Power graph

startTime = P_mech.Time(1);
fig2 = figure;
hold on;
plot(P_mech.Time(P_mech.Data>=0)-startTime, P_mech.Data(P_mech.Data>=0)./1e6, 'Color', '#03ac13', 'LineWidth', 2);
plot(P_mech.Time(P_mech.Data<0)-startTime, P_mech.Data(P_mech.Data<0)./1e6, 'Color', '#b80f0a', 'LineWidth', 2);
mean_mpow = mean(P_mech.Data)./1e6;
yline(mean_mpow, 'Color','#FFA500','LineWidth', 2.5);
yline(0, 'k','LineWidth', 2.5);

legend('Mech Power (+)','Mech Power (-)',sprintf('Mean Power %g [MW]', round(mean_mpow,3)));
xlabel('Time [s]');
ylabel('Mechanical power [MW ]');
xlim([0,500]);
ylim([-20,10]);
grid on;
hold off;