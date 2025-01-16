function signalData = extractSignalOfLastCycle2( signal, sample_count_last_cycle,  simInit )
% Extract 1D data from the last converged power cycle.
%
% Args:
%     signal (double timeseries): Full 1D timeseries simulation output.
%     sample_count_last_cycle (double timeseries): Simulation timeseries 'cycle_signal_counter'.
%     simInit (struct): Structure containing simulation initialisation parameters.
%
% Returns:
%     signalData (double): Extracted power cycle 1D timeseries.
%
% Date:
%     2019-12-01
%
% Authors:
%     Sebastian Rapp, Dylan Eijkelhof (d.eijkelhof@tudelft.nl)

%------------- BEGIN CODE --------------
time_window_last_cylce = sample_count_last_cycle.Data(end) * simInit.Ts_power_conv_check;
idx_time_window_start = find(signal.Time >= signal.Time(end)-time_window_last_cylce,1);
signalData.Data = signal.Data(idx_time_window_start:end);
signalData.Time = signal.Time(idx_time_window_start:end);

%------------- END CODE --------------
end