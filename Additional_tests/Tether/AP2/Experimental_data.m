load('logData_FCC114_1.mat')

[~, ~, ~, ~, ENVMT, ~, ...
            ~, ~, ~, T, ~] = ...
            initAllSimParams_DE2019(6);

kitepos = logData_FCC114_1.NavigationData.packetData.positionNED;
% kitepos1 = logData_FCC114_1.NavigationData.packetData.positionLLH;
kitevel = logData_FCC114_1.NavigationData.packetData.velocityNED;
windvel = logData_FCC114_1.NavigationData.packetData.windSpeed;
windvel = sqrt(windvel(:,1).^2 + windvel(:,2).^2);
time_nav = logData_FCC114_1.NavigationData.time;
time_nav = datetime(time_nav,'ConvertFrom','epochtime','Format','dd-MMM-yyyy HH:mm:ss.SS');

tetherlength = logData_FCC114_1.WinchData.packetData.length_total-logData_FCC114_1.WinchData.packetData.length_on_drum;
reelspeed = logData_FCC114_1.WinchData.packetData.tether_speed;
startdata = find(reelspeed~=0,1);
enddata = find(reelspeed~=0,1,'last');
Ftground = logData_FCC114_1.WinchData.packetData.tether_tension;
time_winch = logData_FCC114_1.WinchData.time;
time_winch = datetime(time_winch,'ConvertFrom','epochtime','Format','dd-MMM-yyyy HH:mm:ss.SS');
%35552:38019 datapoints

% Ftkite = logData_FCC114_1.ProcessedSensorData.packetData.cableTension;
% time_sensor = logData_FCC114_1.ProcessedSensorData.time;
% time_sensor = datetime(time_sensor,'ConvertFrom','epochtime','Format','dd-MMM-yyyy HH:mm:ss.SS');

idx_nav = isbetween(time_nav,time_winch(startdata),time_winch(enddata));
% idx_sensor = isbetween(time_sensor,time_winch(startdata),time_winch(enddata));
new_time_winch = time_winch(startdata:enddata);

Kitepos.signals.values = kitepos(idx_nav,[2,1,3]);
Kitepos.signals.values(:,3) = -Kitepos.signals.values(:,3);
% Kitepos.signals.values(:,2) = -Kitepos.signals.values(:,2);
Kitevel.signals.values = kitevel(idx_nav,[2,1,3]);
Kitevel.signals.values(:,3) = -Kitevel.signals.values(:,3);
% Kitevel.signals.values(:,2) = -Kitevel.signals.values(:,2);
Windvel.signals.values = windvel(idx_nav,:);
tetherlength = tetherlength(startdata:enddata);
% Ft_kite = Ftkite(idx_sensor,:);
Ftground = Ftground(startdata:enddata);

Ft_ground = interp1(new_time_winch,Ftground,time_nav(idx_nav));
Tetherlength.signals.values = interp1(new_time_winch,tetherlength,time_nav(idx_nav));
pos = sqrt(Kitepos.signals.values(:,1).^2+Kitepos.signals.values(:,2).^2+Kitepos.signals.values(:,3).^2);
Tetherlength.signals.values = pos+.5;
% Tetherlength.signals.values = Tetherlength.signals.values-287.5;

simIn.dt = 0.001;
t = 0:simIn.dt:size(kitepos(idx_nav,:),1)*simIn.dt-simIn.dt;
Kitepos.time = t';
Kitepos.signals.dimensions = 3;
Kitevel.time = t';
Kitevel.signals.dimensions = 3;
Windvel.time = t';
Windvel.signals.dimensions = 1;
Tetherlength.time = t';
Tetherlength.signals.dimensions = 1;

T.d_tether = 0.0025;
T.rho_t = 0.0046; %kg/m 

l_j = norm(Kitepos.signals.values(1,:));
phi_init = atan2(Kitepos.signals.values(1,2),sqrt(l_j^2-Kitepos.signals.values(1,2)^2));
if abs(phi_init)<1e-5
    phi_init = 0;
end
theta_init = atan2(Kitepos.signals.values(1,1),Kitepos.signals.values(1,3));

T.Tn_vect = [theta_init; phi_init; 1000]; %theta,phi,force magnitude

T.tether_inital_lenght = Tetherlength.signals.values(1);
T.l0 = T.tether_inital_lenght/(T.np+1);
T.pos_p_init = [];
e_t = Kitepos.signals.values(1,:)'/l_j;
for p = 1 : T.np
    T.pos_p_init = [T.pos_p_init, p*e_t*T.l0];
end
T.pos_p_init = fliplr(T.pos_p_init);

T.eta1 = 0.403362463949762;
T.eta2 = 0.646914366052548;
T.alpha1 = 4.33961097083308;
T.alpha2 = 0.745653460592095;

h_list = -kitepos(idx_nav,3);


h = min(-kitepos(idx_nav,3)):1:max(-kitepos(idx_nav,3));
wv_list = windvel(idx_nav);
wv_list = wv_list(h_list>3.5);
h_list = h_list(h_list>3.5);
weights = [10000*ones(1,numel(h_list(h_list<=120))),1*ones(1,numel(h_list(h_list>120)))];

vw = 5.382*h.^0.1826;
% plot(windvel(idx_nav),-kitepos(idx_nav,3))
% hold on
% plot(vw,h)

out = sim('testing.slx','SrcWorkspace', 'current');

figure;
plot(Ft_ground)
hold on
plot(out.ground_force.Data)

% close all
% fig_fp = figure('Name','Flightpath');
% %3357:end, 62775
% x = -Kitepos.signals.values(:,2);
% y = -Kitepos.signals.values(:,1);
% z = -Kitepos.signals.values(:,3);
% 
% plot3(x,y,z)
% xlabel('x_W [m]','FontSize',16);
% ylabel('y_W [m]','FontSize',16);
% zlabel('z_W [m]','FontSize',16);
% grid on
% axis equal