function force_angle = ISOAngle2Force(angle) % angle should be in rad
% the load formulas from ISO
syms t
F_1cmax=824; % the first peak load
angle_t=2.45074*(10^-12)*t^5-3.75984*(10^-9)*t^4+1.77519*(10^-6)*t^3-1.08409*(10^-4)*t^2+2.07217*(10^-2)*t-20.041;
force_t=F_1cmax*(10^-3)*(5.12306842296552*(10^-12)*t^6-9.2037374110419*(10^-9)*t^5+5.98882225167948*(10^-6)*t^4-1.67101914899229*(10^-3)*t^3+1.64651497111425*(10^-1)*t^2+3.62495690883228*t);

% solve for the load at an specific angle in rad
assume(t >= 0)
assume(t <= 600)
t_angle=double(solve(angle_t==angle*180/pi,t)); % first find the time correspond to that angle
force_angle=double(subs(force_t,t,t_angle));
end