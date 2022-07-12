function [x_catenary,y_catenary,z_catenary] = solve_cat(P1,P2,length)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
        hvec = P2(1:2)-P1(1:2);
        angle1 = atan2(hvec(1),hvec(2));
        h = norm(hvec);
        v = P2(3)-P1(3);
        syms a
        
        eq1 = sqrt(length^2 - v^2) == 2*sinh(a*h/2)/a;
        a_new = double(vpasolve(eq1, a, [1e-10 Inf]));
        
        X = linspace(norm(P1(1:2)),h,100);
        XY = [sin(angle1); cos(angle1)].*X;
        x_left	= 1/2*(log((length+v)/(length-v))/a_new-h);
        x_min		= norm(P1(1:2)) - x_left;
        bias		= P1(3) - cosh(x_left*a_new)/a_new;

        z_catenary = cosh((X-x_min)*a_new)/a_new + bias;
        x_catenary = XY(1,:);
        y_catenary = XY(2,:);
end