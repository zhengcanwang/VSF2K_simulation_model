clc;clear;close all
%%
F_1cmax=824;
syms t;

%% two formula
angle_t=2.45074*(10^-12)*t^5-3.75984*(10^-9)*t^4+1.77519*(10^-6)*t^3-1.08409*(10^-4)*t^2+2.07217*(10^-2)*t-20.041;
force_t=F_1cmax*(10^-3)*(5.12306842296552*(10^-12)*t^6-9.2037374110419*(10^-9)*t^5+5.98882225167948*(10^-6)*t^4-1.67101914899229*(10^-3)*t^3+1.64651497111425*(10^-1)*t^2+3.62495690883228*t);

%% find the exact initial-foot-angle and the end-foot-angle
foot_angle_veryInitial=double(subs(angle_t,t,0));
foot_angle_veryEnd=double(subs(angle_t,t,600));

%% solve for a given angle
angle=2.00871; %% change here
assume(t >= 0)
assume(t <= 600)

t_angle=double(solve(angle_t==angle,t)); % first find the time corespond to that angle
force_angle=double(subs(force_t,t,t_angle))

%% get the angle when OHC (which is at 500ms)
angle_OHC =double(subs(angle_t,t,500))

%% Plot the figure
angles = linspace(foot_angle_veryInitial,foot_angle_veryEnd,100);
for i=1:1:length(angles)
t_angles(i)=double(solve(angle_t==angles(i),t)); 
end
force_angle=double(subs(force_t,t,t_angles));

figure(1)
plot(angles,force_angle,'-k','linewidth',4)
ylim([0,900])
ylabel('Load (N)')
xlabel('Ankle angle (degree)')
grid on