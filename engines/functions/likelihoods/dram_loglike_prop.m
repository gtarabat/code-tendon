function out = dram_loglike_prop(theta, para)


[out,~] = loglike_prop(theta, para);

out = -2*out;

end