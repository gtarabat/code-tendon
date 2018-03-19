function filename_max_gen = findLastGenerationDataFile(datafolder,patnum)
% this function returns the filename of the latest generation
% coresponding to patient patnum

% Note 1: files must be located in datafolder
% Note 2: if no files for patnum have been found, empty string will be returned
% Note 3: function does not check if calculations finished -> if generation
%           files exist the latest will be picked
   
    directory = datafolder;      
    filesAndFolders = dir(directory);     
    filesInDir = filesAndFolders(~([filesAndFolders.isdir]));                    
    stringToBeFound = sprintf('patient_%02i',patnum);
    numOfFiles = length(filesInDir);
    i=1;
    max_gen = 0;
    filename_max_gen = '';
    while(i<=numOfFiles)
      filename = filesInDir(i).name;                             
      found = strfind(filename,stringToBeFound);
      if ~isempty(found)
          expression = '_gen_';
          gen_file = regexp(filename,expression);
          if ~isempty(gen_file)
            gen = str2num(filename(gen_file+length(expression):gen_file+length(expression)+1));
            if max_gen<gen
                max_gen = gen;
                filename_max_gen = filename;
            end
          end
      end
      i = i+1;
    end
end

