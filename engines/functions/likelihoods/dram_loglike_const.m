function out = dram_loglike_const(theta, para)


[out,~] = loglike_const(theta, para);

out = -2*out;

end