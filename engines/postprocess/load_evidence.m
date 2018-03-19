clc; clear;

% n1 = 10;
% n2 = 30;
% Eta_fbr=linspace(1.1,13.1,n1);
% fr_fbr=linspace(0.55,0.85,n2);

% n1 = 10;
% n2 = 30;
% Eta_fbr=linspace(1.1,13.1,n1);
% fr_fbr=linspace(0,1,n2);


data_folder = '../../data/batch_2_4/';

load( fullfile( data_folder,'eta_f.mat' ) )

n1 = length(Eta_fbr);
n2 = length(fr_fbr);


Nth = 3;

ev  = zeros(n1,n2);
MAP = zeros(Nth,n1,n2);



%%

for i = 1 : n1
    for j = 1 : n2
        
        
        file_name_wr = ['theta/theta_moduli_' sprintf('%03d_%03d',i,j) '.mat'];
        
        full_path = fullfile(data_folder,file_name_wr);
        
        if( exist( full_path ,'file') )

            load( full_path )

            % log-evidence
            ev(i,j) = out_master.lnEv;

            % MAP
            [~,ind] = max(out_master.lik);
            MAP(:,i,j) = out_master.theta(ind,:)';
           
            fprintf( '%03d %03d   %f  \n' ,i ,j , ev(i,j) );
%             disp( s ); %#ok<*DSPS>
            
        end
        
    end
end

%%

save(fullfile(data_folder,'evidence.mat'),'ev')
save(fullfile(data_folder,'MAP.mat'),'MAP')