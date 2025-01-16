function [vec_O] = transformFromWtoO(windDirection_rad,vec_W)
% This function transforms a vector from wind reference frame to inertial reference frame.
    %
    % Args:
    %     windDirection_rad (double): Angle between the wind reference frame and the inertial reference frame around the z-axis.
    %     vec_W (3x1 double): Vector in wind reference frame.
    %
    % Returns:
    %     vec_O (3x1 double): Vector in inertial reference frame.
    %
    % Note:
    %     Axis system is not only rotated around the z-axis but also also flipped upside down. :math:`Z_O = -Z_W`.
    %
    % Author:
    %      Sebastian Rapp

M_OW = [cos(windDirection_rad), sin(windDirection_rad), 0;
        sin(windDirection_rad), -cos(windDirection_rad), 0;
        0, 0, -1];

vec_O = M_OW*vec_W;

end
