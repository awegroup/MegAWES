function [targetP_start, targetP_retract] = determine_startPos_retractTarget(pathparam, tetherParams)
    % Setting the start position and retraction target based on given flight pattern.
    %   For each flight pattern a different target point is used during
    %   retractions. This is determined by this function. Additionally, the
    %   start position of the kite for the simulation is also determined.
    %
    % Args:
    %     pathparam (struct): Structure containing pattern specific parameters.
    %     tetherParams (struct): Structure containing tether specific parameters.
    %
    % Returns:
    %     targetP_start (3x1 double): Kite start position in wind reference frame.
    %     targetP_retract (3x1 double): Retraction phase target position in wind reference frame.
    %
    % Author:
    %      Dylan Eijkelhof (d.eijkelhof@tudelft.nl)
    %
    % Date:
    %     2024-10-31
    
    phi_el = pathparam.elevAng;
    theta  = pathparam.polarAng;
    R = tetherParams.minLength*tetherParams.maxLength;
    s = linspace(0,2*pi,100);
    
    xc =  R * cos(phi_el)*cos(theta);      
    yc =  R * cos(phi_el)*sin(theta);       %Center of the circle path
    zc =  R * sin(phi_el);
    
    pc = [xc, yc, zc];
    
    % Define the normal vector to the plane aligned 
    % with the vector btw center (ground station) and center of circle path
    vc_n = pc/norm(pc); %down
    
    % Choose two non-parallel vectors in the plane 
    u = [-cos(phi_el)*cos(theta),cos(phi_el)*sin(theta),cos(phi_el)]; 
    
    % Take the cross product of the two vectors to get a vector orthogonal to the plane 
    v = cross(u, vc_n);
    
    % NED basis for the plane
    e1 = v / norm(u);   %E
    e2 = u / norm(v);   %N
    
    if pathparam.isCircle
        r = pathparam.circRad;
        a=1;     %vertical component
        b=1;     %orizontal component
    
        %Path on the tangent plane in pc
        x = pc(1) + a * r * (cos(s) * e2(1)) + b * r * (sin(s) * e1(1));
        y = pc(2) + a * r * (cos(s) * e2(2)) + b * r * (sin(s) * e1(2));  
        z = pc(3) + a * r * (cos(s) * e2(3)) + b * r * (sin(s) * e1(3));
    
    else
        abooth = pathparam.aBooth;
        bbooth = pathparam.bBooth;
        htau = pathparam.hTau;
        x_s = 1/htau * bbooth .* sin(s) ./ (1 + (abooth/bbooth)^2 .* cos(s).^2);
        y_s = 1/htau * abooth .* sin(s) .* cos(s) ./ (1 + (abooth/bbooth)^2 .* cos(s).^2);
    
        x = pc(1) + x_s * e1(1) + y_s * e2(1);
        y = pc(2) + x_s * e1(2) + y_s * e2(2);  % Path moved tangent to flight sphere
        z = pc(3) + x_s * e1(3) + y_s * e2(3);
    end
    
    xP = real(R * x./ sqrt(x.^2 + y.^2 + z.^2));
    yP = real(R * y./ sqrt(x.^2 + y.^2 + z.^2));  %Projection path on the sphere
    zP = real(R * z./ sqrt(x.^2 + y.^2 + z.^2));
    
    %For simplicity the side of retraction is fixed at positive y axis in wind
    %reference frame, hence the following is possible
    
    if pathparam.isCircle
        [~, i_outer] = min(yP);
        [~, i_upper] = max(zP);
        xretract = sqrt(R^2-(yP(i_outer))^2-zP(i_upper)^2);
        if ~isreal(xretract)
            xretract = 0;
        end
        targetP_retract = [xretract; yP(i_outer); zP(i_upper)];
        targetP_start = [xP(i_upper); yP(i_upper); zP(i_upper)];
    elseif pathparam.direction>0
        [~, i_outer] = min(yP);
        [~, i_upper] = max(zP);
        xretract = sqrt(R^2-yP(i_outer)^2-zP(i_upper)^2);
        targetP_retract = [xretract; yP(i_outer); zP(i_upper)];
        targetP_start = [xP(i_upper); yP(i_upper); zP(i_upper)];
    else
        [~, i_outer] = max(yP);
        [~, i_upper] = max(zP);
        targetP_retract = [xP(i_outer); yP(i_outer)+100; zP(i_outer)];
        targetP_start = [xP(i_upper); yP(i_upper); zP(i_upper)];
    end
end

