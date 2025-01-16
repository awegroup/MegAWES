function signalData = extractSignalOfLastCycle3D( signal, sample_count_last_cycle,  simInit )
% Extract 3D data from the last converged power cycle.
%
% Args:
%     signal (double timeseries): Full 3D timeseries simulation output.
%     sample_count_last_cycle (double timeseries): Simulation timeseries 'cycle_signal_counter'.
%     simInit (struct): Structure containing simulation initialization parameters.
%
% Returns:
%     signalData (double): Extracted power cycle 3D timeseries.
%
% Date:
%     2020-05-01
%
% Authors:
%     Sebastian Rapp, Dylan Eijkelhof (d.eijkelhof@tudelft.nl)

time_window_last_cylce = sample_count_last_cycle.Data(end) * simInit.Ts_power_conv_check;
idx_time_window_start = find(signal.Time >= signal.Time(end)-time_window_last_cylce,1);
signalData.Data(:,1) = signal.Data(idx_time_window_start:end,1,1);
signalData.Data(:,2) = signal.Data(idx_time_window_start:end,2,1);
signalData.Data(:,3) = signal.Data(idx_time_window_start:end,3,1);
signalData.Time = signal.Time(idx_time_window_start:end);

end