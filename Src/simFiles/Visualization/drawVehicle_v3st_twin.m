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

function drawVehicle_v3st_twin(uu)
%drawVehicle_v3st_twin - Real time simulation plotting
%
% Syntax:  drawVehicle_v3st_twin(uu)
%
% Inputs:
%    uu - List containing the below mentioned inputs, section INPUT
%
% Outputs:
%    Output1 - None (PLOT)
%
% Example: 
%    Interpreted Matlab Function: drawVehicle_v3st_twin
%
% Other m-files required: transformFromOtoW.m
% Subfunctions (bottom): drawParticleTether, drawReferencePath,
%                        drawVehicleBody2, rotate_PhiThetaPsi, translate_3D
% STL-files required: plane_thesis_big.stl
%
% Author: Sebastian Rapp, Phd.
% Modified:
% Dylan Eijkelhof, M.Sc.
% Delft University of Technology
% email address: d.eijkelhof@tudelft.nl  
% ??; Last revision: September-2020

%------------- BEGIN CODE --------------

% Set persistent parameters in plot to be updated at each time step
persistent pathpoints
persistent referencePath
persistent handleParticles
persistent Vert
persistent p    

%% INPUT
% Kite position
pn = uu(1); % inertial North position
pe = uu(2); % inertial East position
pd = uu(3); % inertial down position

% Euler angles, kite orientation
phi = uu(4); 
theta = uu(5);
psi = uu(6);

% Simulation time
t = uu(7);

% Number of tether particles
np = uu(8);

% Wind direction
windDir = uu(9);

% Reference flight path
Lbooth.a = uu(10)*uu(11);
Lbooth.b = uu(11);
Lbooth.phi0 = uu(12);

% Tether particle positions
p_t_x = [0;uu( 13      : 13+np-1 );-pn];
p_t_y = [0;uu( 13+np   : 13+2*np-1 ); pe];
p_t_z = [0;uu( 13+2*np : 13+3*np-1 );-pd];

%% INITIALISE PLOT FOR TIME=0
if t==0
    figure(1);
    addToolbarExplorationButtons(gcf) % Adds buttons to figure toolbar
    
    xlabel('x_W (m)');
    ylabel('y_W (m)');
    zlabel('z_W (m)');
    grid on
    box on;
    axis equal; hold on;

    view(45,45); % set the vieew angle for figure
    ax_x = [-200 1500];
    ax_y = [-600 600];
    ax_z = [0 1000];
    axis([ax_x ax_y ax_z]);
    
    % Draw the ground as a green rectangle
    X = [ax_x(1);ax_x(2);ax_x(2);ax_x(1)];
    Y = [ax_y(1);ax_y(1);ax_y(2);ax_y(2)];
    Z = [0;0;0;0];
    c = [0 1 0; 
         0 1 0; 
         0 1 0;
         0 1 0];
    fill3(X,Y,Z, c(:,2),'EdgeColor','none','FaceColor',c(1,:),'FaceAlpha',0.1);

    % Scale the aircraft (bigger/smaller)
    scale = 3; 

    % Import aircraft from stl file
    [F, V, C] = rndread('plane_thesis_big.stl');
    Vert = scale*V';
    
    % Draw kite
    p = drawVehicleBody2(Vert,pn, pe, pd, phi, theta, psi,[], windDir, F, C);

    % Create animated line for path trail
    color = [85/255, 85/255, 85/255 ];
    pathpoints = animatedline('Linestyle','-','color', color, 'Linewidth', 1.5);

    % Draw tether shape
    handleParticles = drawParticleTether(p_t_x,p_t_y,p_t_z,[]);
    
    % Draw lissajous figure, reference path
    s = 0 : 0.01 : 2*pi;
    l_tether = norm(uu(1:3));
    [Lem] = updateBoothLemniscate(l_tether,Lbooth);
    long_P = Lem.b * sin(s) ./( 1+(Lem.a/Lem.b*cos(s)).^2 );
    lat_P =   Lem.a * sin(s).*cos(s) ./ ( 1+(Lem.a/Lem.b*cos(s)).^2 );
    p_P = [ cos(long_P).*cos(lat_P);sin(long_P).*cos(lat_P);sin(lat_P)]*l_tether;
    phi_p_mean = Lbooth.phi0;
    M_WP = [cos(phi_p_mean),0, -sin(phi_p_mean);0, 1, 0;  sin(phi_p_mean),0, cos(phi_p_mean)];
    p_W = M_WP * p_P;
    referencePath = drawReferencePath( p_W(1,:), p_W(2,:), p_W(3,:), []);

%% All other time steps, edit plot
else
    % Update aircraft position
    drawVehicleBody2(Vert, pn, pe, pd, phi, theta, psi, p, windDir, [], []);
    
    % Add the aircraft position to the path trail (path memory)
    pos_W = transformFromOtoW(windDir, [pn;pe;pd]);
    addpoints(pathpoints,pos_W(1), pos_W(2),pos_W(3));

    % Update tether shape
    handleParticles = drawParticleTether(p_t_x,p_t_y,p_t_z, handleParticles);

    % Update lissajous figure
    s = 0 : 0.01 : 2*pi;
    l_tether = norm(uu(1:3));
    [Lem] = updateBoothLemniscate(l_tether,Lbooth);
    long_P = Lem.b * sin(s) ./( 1+(Lem.a/Lem.b*cos(s)).^2 );
    lat_P =   Lem.a * sin(s).*cos(s) ./ ( 1+(Lem.a/Lem.b*cos(s)).^2 );
    p_P = [ cos(long_P).*cos(lat_P);sin(long_P).*cos(lat_P);sin(lat_P)]*l_tether;
    phi_p_mean = Lbooth.phi0;
    M_WP = [cos(phi_p_mean),0, -sin(phi_p_mean);0, 1, 0;  sin(phi_p_mean),0, cos(phi_p_mean)];
    p_W = M_WP * p_P;
    referencePath = drawReferencePath( p_W(1,:), p_W(2,:), p_W(3,:), referencePath);
    
end
%------------- END CODE --------------
end

function handleParticles = drawParticleTether(p_t_x, p_t_y, p_t_z, handleParticles)
    if isempty(handleParticles)
        handleParticles = plot3( p_t_x, p_t_y,p_t_z , '-', 'color', [0.1 0.1 0.1], 'Markersize',2, 'Linewidth', 1.2, 'MarkerFaceColor', [0.3 0.3 0.3]);
    else
        set(handleParticles,'XData',p_t_x,'YData',p_t_y,'ZData',p_t_z);
    end
    drawnow;
end

function referencePath = drawReferencePath(x, y, z, referencePath)
    if isempty(referencePath)
        referencePath = plot3( x, y,z , '-', 'color', [1 0.3 0.3],'Linewidth', 1.5);
    else
        set(referencePath,'XData',x,'YData',y,'ZData',z);
    end
    drawnow;
end

function p = drawVehicleBody2(V, pn, pe, pd, phi, theta, psi, p, windDir, F, C)
    V = rotate_PhiThetaPsi( V, phi, theta, psi );
    V = translate_3D(V, pn , pe, pd);
    V = transformFromOtoW(windDir, V);

    if isempty(p)
    %    [F, ~, C] = rndread('plane_thesis_big.stl');
        col =  [ 57/255, 106/255, 177/255  ];
        p = patch('faces', F, 'vertices' ,V');
        set(p, 'facec', 'b');              % Set the face color (force it)
        set(p, 'FaceVertexCData', C);       % Set the color (from file)
        set(p, 'EdgeColor','none');
        set(p, 'FaceLighting', 'none');
        set(p, 'FaceColor', col );

        view(45,45);
        daspect([1 1 1])
    else
        set(p, 'Vertices', V');
        drawnow
    end
end

function pts = rotate_PhiThetaPsi(pts, phi, theta, psi)
    pts = [ cos(psi)*cos(theta), cos(psi)*sin(phi)*sin(theta) - cos(phi)*sin(psi), sin(phi)*sin(psi) + cos(phi)*cos(psi)*sin(theta);
            cos(theta)*sin(psi), cos(phi)*cos(psi) + sin(phi)*sin(psi)*sin(theta), cos(phi)*sin(psi)*sin(theta) - cos(psi)*sin(phi);
                -sin(theta),                      cos(theta)*sin(phi),                            cos(phi)*cos(theta)] * pts;
end

function pts = translate_3D(pts, pn, pe, pd)
    pts = pts + repmat([pn;pe;pd], 1, size(pts,2));
end