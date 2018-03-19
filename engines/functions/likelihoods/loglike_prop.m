function [out,misc] = loglike_prop(theta, para)

data = para.data;

Np = length(theta(:))-1;
Nd = length(data.y(:));

sigma = theta(end);

model = para.model( data.x, theta(1:Np) );

sse = sum( ( ( data.y - model )./ model ).^2 );

slog = sum( log( abs(model) ) );

out = -0.5*Nd*log(2*pi) - Nd*log(sigma) - slog - 0.5*sse/(sigma.^2)  ;



if( isfield(para,'CMA') && para.CMA)
    out = -out;
end


misc.test = 1;

end