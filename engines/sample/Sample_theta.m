% sample the parameters for all the data set assuming independency, 
% i.e., sample from p(theta_i|data_i,model_i)

clear

addpath('../functions/BASIS/');
addpath('../functions/tools/');
addpath('../functions/likelihoods/');
addpath('../functions/plot_tools/');


%poolObj = gcp('nocreate');
%poolObj.addAttachedFiles('../functions/likelihoods/');

%% Choose model
model   = 'kelvin' ; % linear, surface_growth 

%%
info.model = str2func([model '_model']);
model_folder = ['../functions/models/' model '_model/'];
addpath(model_folder);
info.read_folder  = '../../data/';
info.write_folder = '/cluster/scratch/garampat/batch_1_1/';
info.loglike = 'loglike_prop';

file_name = 'moduli'; 

%poolObj.addAttachedFiles(model_folder); 

% Make the canvas of input data
Eta_fbr=linspace(1.1,13.1,20);
fr_fbr=linspace(0.55,0.9,20);


%Eta_fbr = 13;
%fr_fbr  = 0.85;


for i = 1 : length(Eta_fbr)
    for j = 1 : length(fr_fbr)
        
        % Adapt the name of the Reuslt file      
    	info.file_name_wr = ['moduli_' sprintf('%03d_%03d',i,j) ];

        info.x = [Eta_fbr(i); fr_fbr(j) ];
        info.dim    = 3; % changed from 5 in the general case
        info.beta2  = 0.001;
        info.Ns = 1e4;
        info.cv_tol = 0.6;
        % info.bounds = [   200,   1,  1e-4 ;...
        %                   1500,  600, 3];

        info.bounds = [   200,   1,    1e-4 ;...
                          1500,  2000, 3];

        %%

        % warning('off',  'MATLAB:dispatcher:UnresolvedFunctionHandle' );
        t1 = tic;

        sys_para = Input_theta( file_name ,  info );

        BASIS = BASIS_Master(sys_para);

        toc(t1);
    end
end

save( fullfile(info.write_folder,'eta_f.mat') ,'Eta_fbr','fr_fbr')


warning('off',  'MATLAB:rmpath:DirNotFound' )
rmpath(genpath('../functions'))
