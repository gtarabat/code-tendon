function [sys_para] = Input_theta( file_name, info )


% data folder name
write_data_folder = info.write_folder;
read_data_folder  = info.read_folder;

%% Parallelization settings

% Number of available cpu for parallelization
sys_para.N_cpu = 48;
% Max. length of a chain to control parallel efficiency
% Default: 1 - no bias case (see BASIS paper by Stephen Wu)
sys_para.max_cLen = 1; 

% Scaling parameter for covariance matrix in MCMC proposal (Gaussian)
% (beta^2 in Ching&Chen 2007, suggested 0.04 in the paper) 
sys_para.beta2 =  info.beta2;



%% System settings

% Number of samples at each intermediate stage
sys_para.N_s = info.Ns;
% Number of samples at the last stage (default: same as N_s)
sys_para.N_s_fin = sys_para.N_s;
% Max. number of stages (default: 1000)
sys_para.max_gen = 1000; 
% Number of stages for using burn-in in MCMC (no burn-in = 0, always = inf)
%   (Note: = 1 also gives no burn-in because first stage has no MCMC)
sys_para.Gen_burn = inf;
% Length of burn-in period for each MCMC at each stage (a vector)
% Note: length of N_burn = Gen_burn or else last element of N_burn used
%   when current generation > length of N_burn
sys_para.N_burn = 30;

% Boolean for turning system messages on/off
sys_para.TF_msg = false;
% Boolean for saving intermediate results
sys_para.TF_save = false;

% File name for saving output of BASIS_Master
sys_para.save_file = [write_data_folder 'theta_' info.file_name_wr ];

%% Model and likelihood settings

% Dimension of theta (main model parameter)
sys_para.N_dim = info.dim; %4;
% Hard bounds on the parameter space (theta)
% row 1: min, row 2: max, #column = N_dim
sys_para.hard_bds = info.bounds; 


% Matlab file name and input parameters of likelihood function
% Note: likelihood function must be structured as (order specific)
%   output - log(likelihood value), struct of other output
%   input - sample, struct of all necessary input parameters (in .para)
sys_para.lik.name = info.loglike ;
sys_para.lik.para = load([ read_data_folder file_name ]);
sys_para.lik.para.data.x =info.x; 
sys_para.lik.para.model = info.model;

%% Settings for the annealing power

% covariance tolerance for weights normalization  
% (takes value 0.1 - 1, 0.1: slow transition, 1: fast transition-default)
sys_para.cv_tol = info.cv_tol;

% Settings for limits on power increments
    % 0 = no limit, inf = always use limit
sys_para.N_gen_maxP = 0; % 0 = no limit
    % Note: length of maxP = N_gen_maxP or else last element of maxP used
    %   when current generation > length of maxP
sys_para.maxP = 0.2*ones(sys_para.N_gen_maxP,1);
    % 0 = no limit, inf = always use limit
sys_para.N_gen_minP = 0;
    % Note: length of minP = N_gen_minP or else last element of minP used
    %   when current generation > length of minP
sys_para.minP = 0.0001*ones(sys_para.N_gen_minP,1);
    % Min. initial value for optimization (additional to minP above)
    % Note: it also affects opt. tolerance by default (see below)
sys_para.opt_iniP = 1e-8; % Default = 1e-8

% Settings for optimization for scaling annealing power
% sys_para.opt_setup = optimset('Display','iter','TolX',0.00001,...
%     'TolFun',0.00001,'Algorithm','interior-point');
tmp_tol = min(0.00001,sys_para.opt_iniP);
if sys_para.TF_msg
    sys_para.opt_setup = optimset('Display','iter',...
        'TolX',tmp_tol,'TolFun',tmp_tol,'Algorithm','sqp');
else
    sys_para.opt_setup = optimset('Display','off',...
        'TolX',tmp_tol,'TolFun',tmp_tol,'Algorithm','sqp');
end


%% Prior settings 

% Set up for basic prior options, allow independent pdf for each dimension
% (Ref: http://ch.mathworks.com/help/stats/random.html)
% Each cell contains the name and parameters based on 'random' in Matlab
% Store the parameters as vector in the '.para' cells

for i=1:sys_para.N_dim
    sys_para.pri.name{i} = 'Uniform'; 
    sys_para.pri.para{i} = [ sys_para.hard_bds(1,i) , sys_para.hard_bds(2,i)];
end

% Set up for customized prior random generator and pdf evaluation
% Require:
%   rnd - function that return matrix of samples (N_s x N_dim)
%       (1 output & 1 input - para_custom_rnd)
%   pdf - function that return pdf values (col. vector) of input samples
%       (1 output & 2 input - samples(N_s x N_dim), para_custom_pdf)
%       (*** make sure input order is same as shown above)
%       (*** make sure the output is in log-scale -> -inf when pdf = 0)
% Note: both functions take single para. variable as input, please use
%   struct for 'para_custom_rnd/pdf' if more than one input parameter
%   variable is needed
% Refer to 'tmcmc_master.m' for use of 'name_custom_rnd' and
%   'tmcmc_worker.m' for use of 'name_custom_pdf'
sys_para.pri.TF_custom = false;
sys_para.pri.name_custom_rnd = '';
sys_para.pri.para_custom_rnd = [];
sys_para.pri.name_custom_pdf = '';
sys_para.pri.para_custom_pdf = [];


%% Settings for proposal prior samples and annealing prior

% Set up for proposal samples in the first stage (sub. prior samples)
% Require:
%   prop_theta - provide N_s x N_dim matrix of initial samples
%   prop_val - provide N_s x 1 col. vector of pdf values of ini. samples
% Note: this is only affects the first stage, and is independent to setting
%   of prior. The prior setting is always required even TF_prop = true.
sys_para.TF_prop_pri = false;
sys_para.prop_theta = [];
sys_para.prop_val = [];

% Set up for annealing prior
% Note: suggest to use with TF_prop, i.e., TF_anneal = TF_prop always
sys_para.TF_anneal_pri = sys_para.TF_prop_pri;


%% Start parallel sections
sys_para.spmd_par = false;
if sys_para.N_cpu > 1
	start_parallel( sys_para.N_cpu, sys_para.spmd_par );
end

end
