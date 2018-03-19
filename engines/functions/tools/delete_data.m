%% CAUTION
%% This script deletes all .mat-files in data directory
data_folder = '../../../data/';

% List of sub dirs to clean
sub_dirs{1} = 'simple_system';
sub_dirs{2} = 'pk_system';
sub_dirs{3} = 'simple_system';
sub_dirs{4} = 'improved_system';
%sub_dirs{5} = 'pharmacokinetics';
        
% ignore files with substrings
ignore_files{1} = 'data';
ignore_files{2} = 'ode';
ignore_files{3} = 'CMA';

%% Dialog Window
% Construct a questdlg 
answer = questdlg('Clean data folder?', ...
	'WARNING', ...
	'YES','NO','NO');
% Handle response
switch answer
    case 'YES'
        disp('deleting files..')
        do_delete = true;
    case 'NO'
        disp('Action aborted')
        do_delete = false;
    case 'otherwise'
        disp('Action aborted')
        do_delete = false;
end

%% Delete
if do_delete
    for k = 1:length(sub_dirs)
        path = [data_folder, sub_dirs{k}, '/*.mat'];
        list_files = dir(path);
        for l = 1:length(list_files)
            TF = true;
            for i = 1:length(ignore_files)
                if strfind(list_files(l).name,ignore_files{i})
                    TF = false;
                end
            end
            if TF
                delete([data_folder, sub_dirs{k},'/',list_files(l).name]);
            end
        end
    end
end