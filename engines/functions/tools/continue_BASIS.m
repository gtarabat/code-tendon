function runinfo = continue_BASIS(sys_para)
    %TODO write smart function to restart all unfinished calculations
    
    data = load([sys_para.data_folder sys_para.gen_file]);
    runinfo = data.runinfo;
end

