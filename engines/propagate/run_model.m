clear


model = 'kelvin';



data_folder  = fullfile( '../../data/' );

base_folder = fullfile( '../../data/batch_2_3/' ); 
        
theta_folder = fullfile( base_folder, 'theta/');
pred_folder  = fullfile( base_folder, 'pred/');

addpath(['../functions/models/' model '_model/']);

mfun = str2func([ model '_model']);

Ns = 1e5;

warning('off','MATLAB:dispatcher:UnresolvedFunctionHandle');

%%
file_name = 'moduli_020_006';

theta_file_name = [ 'theta_'  file_name '.mat' ];
load([ theta_folder  theta_file_name ]);

pred_file_name  = fullfile( pred_folder, [ 'pred_' theta_file_name ] );

data = sys_para.lik.para.data;

x = data.x;

y = zeros(Ns,length(data.y));    

for i=1:Ns
    y(i,:) = mfun( data.x , out_master.theta(i,:));
end

y = [ y(:,1),y(:,end) ];

save( pred_file_name, 'x', 'y'  )



warning('off',  'MATLAB:rmpath:DirNotFound' )
rmpath(genpath('../functions'))