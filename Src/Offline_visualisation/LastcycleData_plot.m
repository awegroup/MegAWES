function LastcycleData_plot(struct_var,ylab,xlab)

%% Data plot
figure
Ydata = struct_var.Data;
Xdata = struct_var.Time-struct_var.Time(1);
plot(Xdata,Ydata)
ylabel(ylab)
xlabel(xlab)
hold on; box on; grid on; axis tight;
enhance_plot('times',16,1.5,3,0)

end