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

function p = animation_aircraft(Path_last_cycle,EulAng_last_cycle,windDir,index_set,scale,Tend,fps,t)
%Animate aircraft position
%
% :param Path_last_cycle: Aircraft position
% :param EulAng_last_cycle: Aircraft orientation angles
% :param windDir: Wind direction
% :param index_set: Array containing the indices of the dataset that should be
%                used
% :param scale: Aircraft illustration scale (actual scale/1.2886)
% :param Tend: Video length
% :param fps: Frames per second
% :param t: animation time at particular step, provided by fanimator()
%
% :returns:
%           - **p** - Aircraft plot handle
%
% Example: 
%       | fanimator(axes1,@animation_aircraft,Path_last_cycle,EulAng_last_cycle,...
%       |    ENVMT.windDirection_rad,Tend,fps,t,'AnimationRange',[0 Tend],'FrameRate',fps)
%
% | Other m-files required: None
% | Subfunctions (bottom): drawVehicleBody2, rotate_PhiThetaPsi, translate_3D
% | MAT-files required: plane_image.mat
%
% :Revision: 17-September-2020
% :Author: Dylan Eijkelhof (d.eijkelhof@tudelft.nl)
 
%------------- BEGIN CODE --------------

persistent Vert
persistent F
persistent C

datapoint = index_set(round(((t/(1/fps))+1)));

if t == 0
    datapoint = 1;
elseif datapoint>size(Path_last_cycle.Data,2)
    datapoint = size(Path_last_cycle.Data,2);
elseif t == Tend
    datapoint = size(Path_last_cycle.Data,2);
end
% Draw kite
pn = Path_last_cycle.Data(1,datapoint);
pe = Path_last_cycle.Data(2,datapoint);
pd = Path_last_cycle.Data(3,datapoint);

% Euler angles, kite orientation
phi = EulAng_last_cycle.Data(1,datapoint);
theta = EulAng_last_cycle.Data(2,datapoint);
psi = EulAng_last_cycle.Data(3,datapoint);

if isempty(Vert)
    % Scale the aircraft (bigger/smaller)
%     scale = 6; 
    % Import aircraft from mat file
    Image_kite = load('plane_image.mat','F','Verti','C');
    F = Image_kite.F;
    V = Image_kite.Verti;
    C = Image_kite.C;
    Vert = scale*V';
end
p = drawVehicleBody2(Vert,pn, pe, pd, phi, theta, psi, windDir, F, C);

%------------- END CODE --------------
end

function p = drawVehicleBody2(V, pn, pe, pd, phi, theta, psi, windDir, F, C)
    V = rotate_PhiThetaPsi( V, phi, theta, psi );
    V = translate_3D(V, pn , pe, pd);
    V = transformFromOtoW(windDir, V);

    col =  [ 57/255, 106/255, 177/255  ];
%     col2 = '#00A6D5';
    p = patch('faces', F, 'vertices' ,V');
    set(p, 'facec', 'b');              % Set the face color (force it)
    set(p, 'FaceVertexCData', C);       % Set the color (from file)
    set(p, 'EdgeColor','none');
    set(p, 'FaceLighting', 'none');
    set(p, 'FaceColor', col );
end

function pts = rotate_PhiThetaPsi(pts, phi, theta, psi)
    pts = [ cos(psi)*cos(theta), cos(psi)*sin(phi)*sin(theta) - cos(phi)*sin(psi), sin(phi)*sin(psi) + cos(phi)*cos(psi)*sin(theta);
            cos(theta)*sin(psi), cos(phi)*cos(psi) + sin(phi)*sin(psi)*sin(theta), cos(phi)*sin(psi)*sin(theta) - cos(psi)*sin(phi);
                -sin(theta),                      cos(theta)*sin(phi),                            cos(phi)*cos(theta)] * pts;
end

function pts = translate_3D(pts, pn, pe, pd)
    pts = pts + repmat([pn;pe;pd], 1, size(pts,2));
end