% Explanation:
% If you've saved some runs after running `Run_OneSimulation.m`, you can
% use this file to compare those runs to each other. Make sure to 

%% Load all results and setup stuff for plotting and saving.
clear;
close all;

figure(1)
colors = get(gca, 'colororder');

savedir = "Results/figures/";
addpath('Results/data')
matfiles = dir('Results\data\*.mat');

for i = 1:length(matfiles)
    fname = matfiles(i).name;

    % Better readable name.
    name = replace(fname, '_', ' ');
    name = replace(name, '.mat', '');

    % Loa the data.
    temp = load(fname);
    runs(i) = temp.simOut;

    % Some extra attributes.
    runs(i).name = name;
    runs(i).short_name = name;
    runs(i).color = colors(mod(i-1, 7)+1, :);
end

% Select which ones we want to look at.
i_select = 1:length(matfiles);
i_select = [1,5,7,9];
runs = runs(i_select);

% String representation for storing figures.
runs_short_name = mat2str(i_select);

%% Get the traction part.
% I only want to analyse the first traction phase, so I can save an index
% that indexes this nicely.
for i = 1:length(runs)
    run = runs(i);

    % Find start and finish.
    start_first_traction_idx = find(run.sub_flight_state.Data == 4, 1, 'first');
    start_first_traction = run.sub_flight_state.Time(start_first_traction_idx);
    end_first_traction_idx = find(run.sub_flight_state.Data == 5, 1, 'first');
    end_first_traction = run.sub_flight_state.Time(end_first_traction_idx);

    % Add margin.
    % This really cleans it up!
    % I think it's ok to do this because I don't focus on the transitions
    % in my work, so they're going to be a bit rough.
    margin_sec = 15;  % Tether force has then completely stabilized.
    start_first_traction = start_first_traction + margin_sec;
    end_first_traction = end_first_traction - margin_sec;

    % Some signals are logged at different rates, so there are two indices.
    idx = (run.v_reel.Time > start_first_traction) & (run.v_reel.Time < end_first_traction);
    runs(i).first_traction_idx = idx;

    idx_slow = (run.alpha.Time > start_first_traction) & (run.alpha.Time < end_first_traction);
    runs(i).first_traction_slow_idx = idx_slow;
end


%% vr-Ft curve.
figure(1)
tiledlayout(1,1, 'TileSpacing', 'none', 'Padding', 'none'); nexttile;  % For tight_layout().

v_ro = 0:0.1:15;
C = 7.7008e3;  % Hard-coded for MegAWES.
Ft_ref_massless = 4 * C * v_ro.^2;
plot(v_ro, Ft_ref_massless, '--k', 'LineWidth', 1);
hold on
set(gca,'ColorOrderIndex',1)

for run = runs
    plot(run.v_reel.Data(run.first_traction_idx), ...
         run.TetherForce.Data(run.first_traction_idx), ...
         'Color', run.color)
end


ylabel('Tether force, N')
xlabel('Reel-out speed, m/s')
ylim([0, 2.0e6])
legend('ideal', runs.name, 'Location', 'SouthOutside')
hold off
grid on

saveas(gcf, savedir+runs_short_name+"_vrFt.png")

%% Tether force.
figure(2)
tiledlayout(1,1, 'TileSpacing', 'none', 'Padding', 'none'); nexttile;  % For tight_layout().

for run = runs
    plot(run.TetherForce.Time(run.first_traction_idx), ...
        run.TetherForce.Data(run.first_traction_idx), ...
        'Color', run.color)
    hold on
end

ylabel('Tether force, N')
xlabel('Time, s')
legend(runs.name, 'Location', 'SouthEast')
hold off
grid on

saveas(gcf, savedir+runs_short_name+"_Ft.png")

%% Angle of attack
figure(3)
for run = runs
    plot(run.alpha.Time(run.first_traction_slow_idx), ...
        rad2deg(run.alpha.Data(run.first_traction_slow_idx)), ...
        'Color', run.color)
    hold on
end

ylabel('Angle of attack, deg')
xlabel('Time, s')
legend(runs.name, 'Location', 'SouthEast')
grid on 
hold off

saveas(gcf, savedir+runs_short_name+"_alpha.png")

%% Power output
figure(4)
tiledlayout(1,1, 'TileSpacing', 'none', 'Padding', 'none'); nexttile;  % For tight_layout().

for run = runs
    plot(run.P_mech.Time(run.first_traction_idx), ...
        run.P_mech.Data(run.first_traction_idx), ...
        'Color', run.color)
    hold on
    % TODO: how to do a fair comparison of the mean? -> entire traction
    % phase is maybe better. Or traction+retraction (but retraction doesn't
    % work...) so Energy during traction? Also for a fair comparison they
    % must use similar setpoint for max tether force.

    P_mean = mean(run.P_mech.Data(run.first_traction_idx));
    P_max = max(run.P_mech.Data(run.first_traction_idx));
end

ylabel('Mechanical Power, W')
xlabel('Time, s')
legend(runs.name)
hold off
grid on

saveas(gcf, savedir+runs_short_name+"_P_mech.png")

%% Winch.
% NOTE: the signal `winch_a` is unsaturated but is consequently saturated
% and integrated to get `v_reel`.
figure(5)
subplot(2, 1, 1)
for run = runs
    plot(run.v_reel.Time(run.first_traction_idx), ...
         run.v_reel.Data(run.first_traction_idx), ...
        'Color', run.color)
    hold on
end
legend(runs.name)
grid on
ylabel('Reel-out speed, m/s')
xlabel('Time, s')
ylim([-10, 20])

subplot(2, 1, 2)
for run = runs
    plot(run.winch_a.Time(run.first_traction_idx), ...
         run.winch_a.Data(run.first_traction_idx), ...
         'Color', run.color)
    hold on
end
ylim([-25, 25])
grid on
legend(runs.name)
ylabel('Reel-out acceleration, m/s^2')
xlabel('Time, s')
ylim([-10, 10])

hold off
grid on

saveas(gcf, savedir+runs_short_name+"_winch.png")

%% Power output and tether force distribution (the limits of the system).
figure(6)

x_power = [];
power_mean = [];
x_tether = [];
g = [];
g_labels = [];

% The constant sampling times are saving us here a LOT. If the sampling
% time is not constant these kind of distribution plots need to be adjusted
% for the amount of time that passes at a certain sample!
for i=1:length(runs)
    % TODO: calculate electrical power (including losses).

    powerData = runs(i).P_mech.Data(runs(i).first_traction_idx);
    tetherData = runs(i).TetherForce.Data(runs(i).first_traction_idx);

    x_power = [x_power; powerData];
    power_mean = [power_mean; mean(powerData)];
    x_tether = [x_tether; tetherData];
    
    g = [g; i*ones(length(powerData), 1)];
    g_labels = [g_labels; string(runs(i).name)];
end

g_labels = categorical(g, 1:length(runs), g_labels);


subplot(1, 2, 1)
boxchart(g_labels, x_tether)
grid on
ylabel('tether force [N]')

subplot(1, 2, 2)
boxchart(g_labels, x_power)
grid on
ylabel('power [W]')
hold on
plot(power_mean, '-o')

grid on
saveas(gcf, savedir+runs_short_name+"_P_mech_and_Ft_distribution.png")

% Only mech power distribution.
figure(7)
tiledlayout(1,1, 'TileSpacing', 'none', 'Padding', 'none'); nexttile;  % For tight_layout().

boxchart(g_labels, x_power ./ 1e6)
ylabel('Mechanical power, MW')
hold on
plot(power_mean ./ 1e6, '-o')
grid on

saveas(gcf, savedir+runs_short_name+"_P_mech_distribution.png")

