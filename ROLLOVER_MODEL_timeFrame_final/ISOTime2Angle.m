function angle_t = ISOTime2Angle(time_input) % angle should be in rad
% the load formulas from ISO
syms t
angle_t=2.45074*(10^-12)*t^5-3.75984*(10^-9)*t^4+1.77519*(10^-6)*t^3-1.08409*(10^-4)*t^2+2.07217*(10^-2)*t-20.041;

% solve for angle of a specfic time
angle_t=double(subs(angle_t,t,time_input)); % first find the time correspond to that angle
end