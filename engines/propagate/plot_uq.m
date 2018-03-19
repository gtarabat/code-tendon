    % clear; 

    cols = [    0.8500    0.3250    0.0980
                0.9290    0.6940    0.1250
                0.4940    0.1840    0.5560
                0.4660    0.6740    0.1880
                0.3010    0.7450    0.9330
                0.6350    0.0780    0.1840];



%%            

addpath(genpath('../functions/plot_tools/shadedplot/'));

% model = 'linear';
model = 'surface_growth';
prior = 'lognorm';
postfix = 'all';


data_folder  = '../../data/data_sets/tumLoad/';
pred_folder  = fullfile( '../../data/HBM/tumLoad/reduced-3/', model, '/pred/');

index_file_name = fullfile( data_folder, [ 'index_' postfix '.mat' ] );
load(index_file_name);


%%

% for k = 1:length(index)
% for k = [find(index== 2) find(index==33) find(index==48) ]
% for k = [find(index==16) find(index==21) find(index==24) find(index==30) ]
for k = [find(index== 5) find(index==43) find(index==46) find(index==63) ] 

    file_name = sprintf('%06d',index(k));

    
%     theta_file_name = [ 'IND_theta_' file_name '.mat' ] ; theta_folder = ind_folder;
        theta_file_name = [ 'theta_' prior '_' postfix '_' file_name '.mat' ];

    
    pred_file_name  = fullfile( pred_folder, [ 'pred_'  theta_file_name ] );
    quant_file_name = fullfile( pred_folder, [ 'quant_' theta_file_name ] );
    
%     cols = parula(nv);
    
    load([data_folder file_name '.mat']);
    load( quant_file_name );
    load( pred_file_name );
    
    %% PLOT confidence intervals
    fg = figure(); clf
    fg.Position = [417   667   853   678];

    med = p(end,:);
    
    for i=1:nv
        [~,lt1,lt2] = shadedplot(x, med, p(2*i-1,:), cols(i,:), 'r'); hold on
        delete(lt1);delete(lt2);
        [a,lt1,lt2] = shadedplot(x, med, p(2*i,:), cols(i,:), 'r'); hold on
        delete(lt1); delete(lt2)
        pp(i) = a(2);
    end 
    
    hold on

    
    pd = plot( data.x, data.y, 'ko', 'MarkerFaceColor', 'k' ); 
    plot( data.x(end), data.y(end), 'ko', 'MarkerSize', 12 ); 
    grid on;

    pmean   = plot( x, mean(y), 'k--','LineWidth',3);
    pmedian = plot( x, med, 'k-','LineWidth',3);

    med(end)
    
    str = cell(nv+3,1);
    str{1} = '  measurements';
    str{2} = '  mean';
    str{3} = '  median';
    for i=1:nv
        str{3+i} = sprintf('  %2.0f%%  credible interval',100*(v(2*i)-v(2*i-1))) ;
    end
    
    lgnd = legend( [ pd pmean pmedian pp], str );
    
    lgnd.Location = 'best';

    grid on

    xlabel('time')
    ylabel('tumor load')
    
    title(['HB sampling for patient ' sprintf('%04d',index(k)) ', ' model ' model' ],'Interpreter','none')
    
    ax = gca;
    ax.FontName = 'Times';
    ax.FontSize = 20;
    axis tight
    
    set(gcf, 'Position', [100, 100, 1049, 895]);
    plotfile = [pred_folder 'quant_' postfix '_' sprintf('%04d',index(k)) '.eps'];
    saveas(gcf, plotfile,'eps2c');
end




warning('off',  'MATLAB:rmpath:DirNotFound' )
rmpath(genpath('../functions'))

