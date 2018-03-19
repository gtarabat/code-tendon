function [ res, misc ] = loglike_smMALA_prop( theta, para )
%
% Likelihood for the smMALA sampling with proprional error.
%

data = para.data;

sigma  = theta(end);
sigma2 = sigma.^2;
sigma3 = sigma.^3;

Np  = length(theta);
Nth = Np-1;
Nd  = length(data.y);

%% model + derivatives evaluation
Y =   my_model( data.x, theta(1:Nth) );
D = d_my_model( data.x, theta(1:Nth) );

%% auxiliary 
Y2 = Y.^2;
ndif = ( Y - data.y(:) ) ./ Y;
nsse = sum( ndif.^2 );

tD = D ./ repmat(Y',Nth,1);

A = sum(tD,2);

tmp = data.y(:) .* ndif ./ Y2 ;
B = D * tmp / sigma2;


%% log-likelihood
slog = sum( log( Y2 ) );
loglike = -0.5*Nd*log(2*pi) - 0.5*Nd*log(sigma2) - 0.5*slog - 0.5*nsse/sigma2 ;

%%  Gradient of log-likelihood
D_loglike = zeros(Np,1);

D_loglike(1:Nth) = - A - B;

D_loglike(end)   = -Nd./sigma + nsse/sigma3;


%% Fisher Information Matrix of likelihood
FIM = zeros(Nth+1);
 
FIM(1:Nth,1:Nth) = (D*D')/sigma2 + 2*(tD*tD') ;

FIM(1:Nth,end) = 2 * A / sigma ;

FIM(end,1:Nth) = FIM(1:Nth,end)';

FIM(end,end) = 2*Nd/sigma2;


%% inversions and eigenvalues
inv_FIM = inv(FIM);

[V,D] = eig(inv_FIM);
D = diag(D);
posdef = all( D>0 );


%% return results
res = loglike;

misc.check = 0;
misc.gradient =  D_loglike;
% negative inverse Hessian
misc.inv_neg_hessian  = inv_FIM;
% eigenvectors and eigenvalues of negative inverse Hessian
misc.eig.V = V;
misc.eig.D = D; % eigenvalues in vector
misc.posdef = posdef;


end



