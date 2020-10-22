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

function FileName = animate_flightpath_torque(FileName, P_mech_last_cycle,...
    Path_last_cycle, EulAng_last_cycle, Tether_last_cycle_x,...
    Tether_last_cycle_y, Tether_last_cycle_z, ENVMT, Tend,fps)
%animate_flightpath_torque - Create flight path animation
%
% Inputs:
%    FileName               - Name of the video file, including extension
%                             If [] is provided, no video file is created
%    P_mech_last_cycle      - Instantaneous power
%    Path_last_cycle        - Aircraft position
%    EulAng_last_cycle      - Aircraft orientation angles
%    Tether_last_cycle_x    - Tether particle x positions
%    Tether_last_cycle_y    - Tether particle y positions
%    Tether_last_cycle_z    - Tether particle z positions
%    ENVMT                  - Environment data for wind direction
%    Tend                   - Video length
%    fps                    - Video frames per second
%
% Outputs:
%    noVar - Video file
%    FileName - The video file name (if created) else empty array
%
% Example: 
%       animate_flightpath_torque('test.mp4',P_mech_last_cycle,...
%       Path_last_cycle,EulAng_last_cycle,Tether_last_cycle_x,...
%       Tether_last_cycle_y,Tether_last_cycle_z,ENVMT,45,30);
%
%       animate_flightpath_torque([],P_mech_last_cycle,...
%       Path_last_cycle,EulAng_last_cycle,Tether_last_cycle_x,...
%       Tether_last_cycle_y,Tether_last_cycle_z,ENVMT,45,30);
%
% Other m-files required: animation_aircraft.m, animation_tether.m,
%                         animation_simtime.m, animation_colorbar.m
% Subfunctions: None
% MAT-files required: None
%
% Author: Dylan Eijkelhof, M.Sc.
% Delft University of Technology
% email address: d.eijkelhof@tudelft.nl  
% September 2020; Last revision: 28-September-2020

%------------- BEGIN CODE --------------

% Graph axis limits

limitz = [0 1200];
limity = [-600 600];
limitx = [-100 1600];

%% File name check
% Check whether filename exists to prevent unwanted overwriting of the file
if isempty(FileName)
    WriteFileFlag = 0;
else
    WriteFileFlag = 1;
end

if WriteFileFlag
    if exist(FileName,'file')
        answer = questdlg('Filename already exists, what to do?', ...
            'File name exists', ...
            'Overwrite','Change filename','Exit','Exit');
        % Handle response
        switch answer
            case 'Overwrite'
                %
            case 'Change filename'
                prompt = {'Enter filename:'};
                dlgtitle = 'Filename';
                definput = {FileName};
                dims = [1 35];
                FileName2 = inputdlg(prompt,dlgtitle,dims,definput);
                FileName2 = FileName2{1};
                if strcmp(FileName,FileName2)
                    answer2 = questdlg('Filename is the same as the original, continue to overwrite?', ...
                                'File name will be overwritten', ...
                                'Ok','Exit','Exit');
                    % Handle response
                    switch answer2
                        case 'Ok'
                            FileName = FileName2;
                        case 'Exit'
                            error('Exit requested')
                        case ''
                            error('Exit requested')
                    end
                elseif strcmp(FileName2,'')
                    error('No filename given, process abort')
                else
                    FileName = FileName2;
                end
            case 'Exit'
                error('Exit requested')
            case ''
                error('Exit requested')
        end
    end
end
%% Initiate Plot
close all
fig_pow = figure(1);
set(gcf, 'Position',  [100, 100, 1400, 1000])
axes1 = axes('Parent',fig_pow,'Position',[0.13,0.11,0.678584552871244,0.815]);
hold(axes1,'on');
fig_pow.Renderer = 'painters';
view([20 47])
% set(gca,'XColor', 'none','YColor','none','ZColor','none')
set(gcf, 'color', 'white');
% set(gca, 'color', 'white');

% Flight path coloured by power
sizeScatter = 5;
Power = P_mech_last_cycle.Data./1e6;
scatter3(-Path_last_cycle.Data(1,:),Path_last_cycle.Data(2,:),-Path_last_cycle.Data(3,:),sizeScatter*ones(size(Power)),Power,'filled'); hold on
enhance_plot('Helvetica',25,2,20,0)

% Colorbar
LimitsColorBar = [floor(min(Power)/1)*1 ceil(max(Power)/1)*1];
cb = colorbar('peer',axes1,'Location','eastoutside','FontSize',16);
cb.Label.String = 'Power, MW';
caxis(LimitsColorBar)
cb.FontSize = 16;
cb.Location = 'eastoutside';
cb.Position = [0.874536933823625,0.111493416432584,0.010666666666667,0.815];   
cb.Label.FontSize = 16;

% Graph limits
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

%% Obtain extra data required for animation

% Combine tether coordinates
Tether_last_cycle.Data(1,:,:) = Tether_last_cycle_x;
Tether_last_cycle.Data(2,:,:) = Tether_last_cycle_y;
Tether_last_cycle.Data(3,:,:) = Tether_last_cycle_z;

%% Animation
syms t;

% fps = 30;

% Create textbox
annotation(figure(1),'textbox',...
    [0.0581428571428571 0.0452488687782827 0.210428571428571 0.0407239819004553],...
    'String',{'(Kite is not illustrated to scale)'},...
    'FontSize',16,...
    'FontAngle','italic',...
    'FitBoxToText','off',...
    'EdgeColor','none');
index_set = round(linspace(1,size(Path_last_cycle.Data,2),Tend*fps+1));
fanimator(axes1,@animation_tether,Path_last_cycle,Tether_last_cycle,index_set,Tend,...
    fps,t,'AnimationRange',[0 Tend],'FrameRate',fps)

fanimator(axes1,@animation_aircraft,Path_last_cycle,EulAng_last_cycle,...
    ENVMT.windDirection_rad,index_set,Tend,fps,t,'AnimationRange',[0 Tend],'FrameRate',fps)

TimePos = [0.6*limitx(2), limity(2), limitz(2)];
fanimator(axes1,@animation_simtime,Path_last_cycle,TimePos,index_set,Tend,...
    fps,t,'AnimationRange',[0 Tend],'FrameRate',fps)

h_axes = axes('Parent',fig_pow,'position', cb.Position, 'ylim', cb.Limits, ...
    'color', 'none', 'visible','off');

index_set = round(linspace(1,numel(Power),Tend*fps+1));
fanimator(h_axes,@animation_colorbar,Power,index_set,Tend,...
    fps,t,'AnimationRange',[0 Tend],'FrameRate',fps)

h_axes.Visible = 'off'; % fanimator adjust axis, so revert back to match original
h_axes.YLim = cb.Limits; % fanimator adjust axis, so revert back to match original

if WriteFileFlag
    vidObj = VideoWriter(FileName,'MPEG-4');
    vidObj.FrameRate = fps;
    open(vidObj)
    writeAnimation(vidObj,'AnimationRange',[0 Tend],'FrameRate',fps)
    close(vidObj)
end

disp('Done')
%------------- END CODE --------------
end