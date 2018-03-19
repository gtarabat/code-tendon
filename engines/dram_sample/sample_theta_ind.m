clear; clc

addpath(genpath('../functions/DRAM/'))
addpath('../functions/likelihoods/');

%% Choose model
model   = 'surface_growth' ; % linear, surface_growth 
sex     = 'all' ;         % male, female or all


info.model = str2func([model '_model']);
addpath([ '../functions/models/' model '_model/']);
read_folder  = '../../data/data_sets/tumLoad/';
write_folder = ['../../data/HBM/tumLoad/' model '/post_opt/'];

file_name = [ read_folder 'index_' sex '.mat'];
load(file_name);

%%


prob.ssfun    = 'dram_loglike_prop';
prob.priorfun = @(x,par) -2*log(unifpdf(x(1),0,1)*unifpdf(x(2),0,1)*unifpdf(x(3),0,1)) ;

params.par0    = [ 0.5, 0.1, 0.1 ]; % initial value
options.nsimu    = 1e5;
options.adaptint = 10;
options.drscale  = 4;
options.qcov     = eye(3)*1; % initial covariance 

%%
t1 = tic;

% for k = 1 : length(index)
for k = 1
    fprintf('Bayes on data set: %03d / %4d \n',k, length(index) )

    file_name =  sprintf('%06d',index(k));
    save_file = [ write_folder 'IND_theta_' file_name ];
    load_file = [ read_folder file_name ];
    
    load(load_file)
    
    para.data = data;
    para.model = str2func('surface_growth_model');
    [results,chain] = dramrun( prob, para, params, options );
    chain = chain(1e3:end,:);
    
    save(save_file,'chain');
    
end

toc(t1);

warning('off',  'MATLAB:rmpath:DirNotFound' )
rmpath(genpath('../functions'))

 