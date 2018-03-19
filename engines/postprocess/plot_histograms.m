
load ../../data/batch_2_3/theta/theta_moduli_020_020.mat

figure(1);

[h,ax,BigAx,hhist,pax] = plotmatrix_hist(out_master.theta(:,1:2));


f=gcf;
f.Position = [1000         345        1210         993];
    
var_names = {'$E_{fbr}$','$\eta_m$'};

N = 2;

for i=1:N
    
    ax(N,i).XLabel.Interpreter='latex'; 
    ax(N,i).XLabel.String = var_names{i}; 
    ax(N,i).FontSize = 26;
    
    ax(i,1).YLabel.Interpreter='latex'; 
    ax(i,1).YLabel.String=var_names{i}; 
    ax(i,1).FontSize = 26;
end


savefig( 'posterior_theta_samples' );
saveas(f,'posterior_theta_samples', 'epsc' );

%%


[f,x] = ecdf(out_master.theta(:,2));
plot(x,f,'LineWidth',3)
grid on


hold on

i=find(f>0.05,1,'first');
plot([x(i) x(i)],[0 f(i)],'r','LineWidth',3)

disp([x(i) f(i)])

i=find(f<0.95,1,'last');
plot([x(i) x(i)],[0 f(i)],'r','LineWidth',3)

disp([x(i) f(i)])