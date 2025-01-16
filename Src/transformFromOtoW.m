function [vec_W] = transformFromOtoW(windDirection_rad,vec_O)
% This function transforms a vector from inertial reference frame to wind reference frame.
    %
    % Args:
    %     windDirection_rad (double): Angle between the wind reference frame and the inertial reference frame around the z-axis.
    %     vec_O (3x1 double): Vector in inertial reference frame.
    %
    % Returns:
    %     vec_W (3x1 double): Vector in wind reference frame.
    %
    % Note:
    %     Axis system is not only rotated around the z-axis but also also flipped upside down. :math:`Z_W = -Z_O`.
    %
    % Author:
    %      Sebastian Rapp

M_WO = [cos(windDirection_rad), sin(windDirection_rad), 0;
        sin(windDirection_rad), -cos(windDirection_rad), 0;
        0, 0, -1];

vec_W = M_WO*vec_O;

end
