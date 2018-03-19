% infer the parameters for the k-th data set by optimizing the likelihood
clc; clear


k = 1;


data_folder = '../../data/';


addpath('../functions/tools')
addpath('../functions/CMA')
addpath('../functions/kelvin_model/')
addpath('../functions/likelihoods/');

loglike_func = 'loglike_prop';

model = 'kelvin';

model_folder = ['../functions/models/' model '_model/'];
addpath(model_folder);



file_name = [ data_folder 'moduli.mat'];

data = load(file_name);

data.CMA = true;

data.model = str2func([model '_model']);




%% Options
% change warning of ode15s on Tolerance to error for catching
warnId = 'MATLAB:ode15s:IntegrationTolNotMet';
warnstate = warning('error', warnId);

start_parallel(2, false );

opts.CMA.active = 0;
opts.PopSize = 1000; % population size in every generation
opts.Resume = 0;
opts.MaxFunEvals = 300000;
opts.LBounds = [ 1e2,   .2 ,  1.4 ,  1e-2,  1e-4 ]';    % upper bound in search space
opts.UBounds = [ 2e3,   .3 ,     13.1,   1000,  5]';       % lower bound in search space
opts.Noise.on = 0;
opts.LogModulo = 1;
opts.LogPlot = 1;
opts.DispModulo = 1;
opts.EvalParallel = 1;
opts.EvalInitialX = 1;
opts.TolX = 1e-12;


opts.SaveFilename = [ data_folder 'opt_theta.mat'];
opts.LogFilenamePrefix = [ data_folder 'outcmaes_'];


xinit = [ 400 0.25 3000 3000 1 ]';


CMA = cmaes_parfor( loglike_func,  xinit,[], opts, data);
%%
disp(CMA)



warning('off',  'MATLAB:rmpath:DirNotFound' )
rmpath(genpath('../functions'))