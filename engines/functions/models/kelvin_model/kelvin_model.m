function y = kelvin_model(x,theta)
% X1> eta_1
% X2 fr
    
    y = zeros(5,1);
    
    eta1 = x(1);
    fr   = x(2);
    const = sind(75)^3;
    
    
    y1 = fr*theta(1)*const + (1-fr)*0.25;  %theta(2) Modulus of matrix
    y2 = fr*eta1 + (1-fr)*theta(2);  %theta(3) viscosity of fiber

    y(1:3) = y1;
    y(4:5) = y2;
    
    
    
    
    % set inf or nan to something large. otherwise nlmefitsa complains
    y(~isfinite(y)) = 1e300;
    
end
