clear; 

model = 'kelvin';

data_folder  = fullfile( '../../data/' );

base_folder = fullfile( '../../data/batch_2_3/' ); 
        
theta_folder = fullfile( base_folder, 'theta/');
pred_folder  = fullfile( base_folder, 'pred/');

addpath(['../functions/models/' model '_model/']);

mfun = str2func([ model '_model']);

Ns = 1e4;

warning('off','MATLAB:dispatcher:UnresolvedFunctionHandle');

%%
file_name = 'moduli_020_006';


theta_file_name = [ 'theta_'  file_name '.mat' ];
load( fullfile( theta_folder,theta_file_name) );

pred_file_name  = fullfile( pred_folder, [ 'pred_' theta_file_name ] );
load(pred_file_name);
        

th = out_master.theta; clear out_master;

n1 = size(y,1);
n2 = size(y,2);

sigma = th(1:n1,end);
    

xx{1} = 1:1:2000;
xx{2} = 1:1:200;

ylabel = {'Fiber Modulus $E_f,$ (MPa)', 'Viscosity $\eta,$ (GPa$\cdot$s)'};


v = [ 0.5 0.05 0.95];


fname = {'pdf_1','pdf_2'};

for i = 1 : n2

    mu = y(:,i);
    Sigma = ( sigma.*mu ) ;       
    f = @(x) sum( normpdf(x,mu, Sigma ) )/n1; 
    g = @(x) sum( normcdf(x,mu, Sigma ) )/n1; 

    
    yy = zeros(1,length(xx{i}));
    for k=1:length(xx{i})
        yy(k) = f(xx{i}(k) );
    end
    
    
    
    x0 = median(y(:,i));
    for m = 1:length(v)
        z(m) = fzero( @(x)g(x)-v(m), x0 );
    end
    
    men = mean(mu);
    med = z(1);

    fh=figure(i); clf
    fh.Position = [1000 448 1093 890];
    
    p = plot(xx{i},yy); hold on
    p.LineWidth = 3;
    p.Color = 'k';
    
    
    p = plot([men men],[0 f(men)],'--');
    p.LineWidth = 2;
    p.Color = 'r';
    
    p = plot([med med],[0 f(med)],'--');
    p.LineWidth = 2;
    p.Color = 'b';
    
    p = plot([z(2) z(2)],[0 f(z(2))],'--');
    p.LineWidth = 2;
    p.Color = 'k';
    
    p = plot([z(3) z(3)],[0 f(z(3))],'--');
    p.LineWidth = 2;
    p.Color = 'k';
    
    
    l = legend('  pdf','  mean', '  median', '  5%-95% interval');
    
    ax=gca;
    
    ax.XLabel.String = ylabel{i};
    ax.XLabel.Interpreter = 'latex';
    ax.FontSize = 36;

    grid on
    axis tight
   
    
    savefig( fname{i} );
    saveas(fh,fname{i}, 'epsc' );
    
end



% save(quant_file_name,'p','q','x','v','nv');




warning('off',  'MATLAB:rmpath:DirNotFound' )
rmpath(genpath('../functions'))





