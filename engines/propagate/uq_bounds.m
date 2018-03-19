clear; 

warning('off','MATLAB:dispatcher:UnresolvedFunctionHandle');

addpath(genpath('../functions/plot_tools/boundedline/'));

% model = 'linear';
model = 'surface_growth';
postfix = 'all';
prior = 'lognorm';

data_folder  = '../../data/data_sets/tumLoad/';
base_folder = fullfile( '../../data/HBM/tumLoad/reduced-3/', model ); 
        
theta_folder = fullfile( base_folder, 'theta/');
ind_folder   = fullfile( base_folder, 'ind/');
pred_folder  = fullfile( base_folder, 'pred/');

index_file_name = fullfile( data_folder, [ 'index_' postfix '.mat' ] );
load(index_file_name);

% quantile percentage
% q = 10:10:90;
% q = [ 0.1  q 95  99.99];
q = [99 95 90 70];

%%
q = sort(q,'descend');
q = q/100;
nv = length(q);
v = zeros(2*nv+1,1);
v(end) = 0.5;

for i=1:nv
    v(2*i-1) = 0.5 - q(i)/2;
    v(2*i)   = 0.5 + q(i)/2;
end
%%



% for k = 1:length(index)
% for k = [find(index== 2) find(index==33) find(index==48) ]
% for k = [find(index==16) find(index==21) find(index==24) find(index==30) ]
for k = [find(index== 5) find(index==43) find(index==46) find(index==63) ] 
    
    disp(k)

    file_name = sprintf('%06d',index(k));
    data_file_name  = fullfile( data_folder, [file_name '.mat'] );
    
%     theta_file_name = [ 'IND_theta_' file_name '.mat' ] ; theta_folder = ind_folder;
    theta_file_name = [ 'theta_' prior '_' postfix '_' file_name '.mat' ];

    
    pred_file_name  = fullfile( pred_folder, [ 'pred_'  theta_file_name ] );
    quant_file_name = fullfile( pred_folder, [ 'quant_' theta_file_name ] );
    
    load(data_file_name);
    load( fullfile( theta_folder,theta_file_name) );
    load(pred_file_name);
        
    th = out_master.theta; clear out_master;
%     th = chain;
    

    n1 = size(y,1);
    n2 = size(y,2);

    sigma = th(1:n1,end);
    %%

    p = zeros(length(v),n2);

    for i = 1 : n2

        mu = y(:,i);
        Sigma = ( sigma.*mu ).^2 ;       
        f = @(x) sum( normcdf(x,mu, sigma ) )/n1;    

        x0 = median(y(:,i));
        for m = 1:length(v)
            p(m,i) = fzero( @(x)f(x)-v(m), x0 );
        end

        
        
    end

    save(quant_file_name,'p','q','x','v','nv');

end


warning('off',  'MATLAB:rmpath:DirNotFound' )
rmpath(genpath('../functions'))







% 
% 
% clf
% 
% x=data.y(1)-500:1:data.y(end)+400; 
% 
% for i=1:length(x)
%     yy(i)=f(x(i)); 
% end
% 
% plot(x,yy,'.'); 
% hold on; 
% plot(data.y(2),0,'o')
% 
% grid on
% 
% 
% 
% for i=1:length(v)
%     
%     
%     plot( [p(i,2),p(i,2) ] , [0,v(i)] , 'k')
%     
% end