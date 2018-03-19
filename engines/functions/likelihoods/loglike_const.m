function [out,misc] = loglike_const(theta, para)



data = para.data;

Np = length(theta(:))-1;
Nd = length(data.y(:));

std_data = theta(end)*1e3;

model = para.model( data.x, theta(1:Np) );

sse = sum( ( data.y - model ).^2 );

out = -0.5*Nd*log(2*pi) - Nd*log(std_data) - 0.5*sse/(std_data.^2) ;



if( isfield(para,'CMA') && para.CMA)
    out = -out;
end


misc.test = 1;

end