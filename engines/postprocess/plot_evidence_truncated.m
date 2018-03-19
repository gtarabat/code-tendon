clc; clear; close all

% n1 = 10;
% n2 = 30;
% Eta_fbr=linspace(1.1,13.1,n1);
% fr_fbr=linspace(0.55,0.85,n2);


% n1 = 10;
% n2 = 20;
% Eta_fbr=linspace(1.1,13.1,n1);
% fr_fbr=linspace(0.5,0.95,n2);


data_folder = '../../data/batch_2_1/';

load( fullfile( data_folder,'eta_f.mat' ) )

n1 = length(Eta_fbr);
n2 = length(fr_fbr);


[X,Y] = meshgrid(Eta_fbr,fr_fbr);

Nth = 3;

ev_  = zeros(n1,n2);
MAP_ = zeros(Nth,n1,n2);


%% 

Nf = 4;

for i=1:Nf 
    
    data_folder = [ '../../data/batch_2_' num2str(i) '/'];
    load(fullfile(data_folder,'evidence.mat'));
    load(fullfile(data_folder,'MAP.mat'));

    ev_ = ev_ + ev;
    MAP_ = MAP_ + MAP;
    
end


ev_  = ev_ / Nf;
MAP_ = MAP_ / Nf;

%%


ind1 = 1:n1;
ind2 = 1:n2;


fname ={'model_probability','MAP_1','MAP_2'};
an_str = { '$p(\mathcal{M}|d)$' , '$E_{fbr}$ (MPa)', '$\eta_m$ (GPa$\cdot$s)'};
an_pos = {[0.8446    0.9521    0.0763    0.0342],[0.8181    0.9215    0.2092    0.0688],[0.8181    0.9215    0.2092    0.0688]};
fntsz = [26 38 38];

for i = 1

    if(i==1)
        Z = exp(ev_(ind1,ind2));
        Z = Z/sum(Z(:));
        Z = Z';
        str = '$p(d | \mathcal{M})$';
    else
        Z = squeeze(MAP(i-1,ind1,ind2))';
        str = ['MAP - $\vartheta_{' num2str(i-1) '}$'];
    end
    
    f=figure(i); clf;
    f.Position = [1000         345        1210         993];
    
    
    s = surfc( X(ind1,ind2), Y(ind1,ind2), Z );
    
    s(1).FaceColor = 'interp';
    s(1).EdgeColor = 'none';
    s(1).FaceAlpha = 0.8;
    
    s(2).LineWidth = 3;
%     s(2).LineColor='k';
    
    ax=gca;

    ax.XLabel.Interpreter='latex'; ax.XLabel.String='$\eta_{fbr}$'; 
    ax.YLabel.Interpreter='latex'; ax.YLabel.String='$f_{fbr}$'; 
    ax.ZLabel.Interpreter='latex'; ax.ZLabel.String=str; 
    ax.FontSize = fntsz(i);
    ax.View = [58.5 24.5];
    axis tight

    colorbar
    
    view(0,90)
    
    
    dim = [0.0 0.5 0.5 0.3];
    str = {'Straight Line Plot','from 1 to 10'};
    
    an=annotation('textbox',dim,'String',str,'FitBoxToText','on');
    an.Interpreter='latex';
    an.FontSize = fntsz(i);
    an.String = an_str{i};
    an.LineStyle = 'none';
    an.Position = an_pos{i};
    
    savefig( fname{i} );
    saveas(f,fname{i}, 'epsc' );
    
end

% ax.ZScale='log';


%% 

[~,I]=max(ev_(:)); 
[i,j]=ind2sub([20,20],I);

fprintf('Maximum probability at index %i %i\n',i,j)
fprintf('Maximum probability at eta=%f f=%f\n',Eta_fbr(i),fr_fbr(j))


