function [ res, misc ] = loglike_smMALA_const( theta, para )
%
% Likelihood for the smMALA sampling with constant error.
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

dif = ( data.y(:) - Y );
sse = sum( dif.^2 );


%% log-likelihood

loglike = -0.5*Nd*log(2*pi) - 0.5*Nd*log(sigma2) - 0.5*sse/sigma2 ;

%%  Gradient of log-likelihood
D_loglike = zeros(Np,1);

D_loglike(1:Nth) = D * dif / sigma2 ;

D_loglike(end)   = -Nd./sigma + sse/sigma3;


%% Fisher Information Matrix of likelihood
FIM = zeros(Nth+1);
 
FIM(1:Nth,1:Nth) = (D*D')/sigma2 ;

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



