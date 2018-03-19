function y = kelvin_model_one(x,theta)
% X1> eta_1
% X2 fr
    
    y = zeros(2,1);
    
    eta1 = x(1);
    fr   = x(2);
    const = sind(75)^3;
    
    
    y(1) = fr*theta(1)*const + (1-fr)*0.25;  %theta(2) Modulus of matrix
    y(2) = fr*eta1 + (1-fr)*theta(2);  %theta(3) viscosity of fiber

    
    
    
    
    
    % set inf or nan to something large. otherwise nlmefitsa complains
    y(~isfinite(y)) = 1e300;
    
end
