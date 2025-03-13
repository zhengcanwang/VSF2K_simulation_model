%% this function calculate from two sides (fore and hind) in stage2_2 (toe-fix) and they should be match
function [F] = FIND_boundaryofFF_from_secondHalf(x,theta_hind_offset,theta_fore_offset,a_fore,a_hind)
%% two unknowns
theta_foot_FF_boundary=x(1); % in rad
shift_FF_boundary=x(2);

%% The load at this load at this foot angle (and equally shared by fore and hind foot)
force_angle = ISOAngle2Force(theta_foot_FF_boundary);
P_hind=force_angle/2;
P_fore=force_angle/2;

%% For hind foot %%
%% Set the fulcrum position, the load, and the rollingangle for core
a=a_hind;

P=P_hind;

theta_hind_offset_rad=theta_hind_offset*pi/180; % Just change the netual angle to radians
rolling_angle_hind_ATboundary=theta_hind_offset_rad-theta_foot_FF_boundary; % see geometry analysis
rolling_angle=rolling_angle_hind_ATboundary*180/pi; % in degree

%% start the core for hind foot
[x_contact_new,deflectionATContact]=core(a, rolling_angle, P*cosd(rolling_angle), "hind"); % input in degree, meter, and N

%% Get y or m
HindFoot_design;
y = L-x_contact_new -(-deflectionATContact)/tan(rolling_angle*pi/180); 

%% get fake ankle in moving heel coordinate
ankle_z_hind=sin(rolling_angle*pi/180)*y;
ankle_x_hind=cos(rolling_angle*pi/180)*y+(L-y)/(cos(rolling_angle*pi/180));
ankle_y_hind = 0;

%% Removes all variables from the current workspace except:
clearvars -except theta_foot_FF_boundary shift_FF_boundary x(1) x(2) ankle_z_hind ankle_x_hind ankle_y_hind y P_hind P_fore...
                  theta_fore_offset a_fore;

%% For fore foot %%
%% Set the fulcrum position, the load, and the rollingangle for core
a=a_fore;

P=P_fore;

theta_fore_offset_rad=theta_fore_offset*pi/180; % Just change the netual angle to radians
rolling_angle_fore_ATboundary=theta_fore_offset_rad+theta_foot_FF_boundary; % see geometry analysis
rolling_angle=rolling_angle_fore_ATboundary*180/pi; % in degree

%% start the core for fore foot
[x_contact_new,deflectionATContact]=core(a, rolling_angle, P*cosd(rolling_angle), "fore"); % input in degree, meter, and N

%% Get y or m
ForeFoot_design;
m = double(L-x_contact_new-(-deflectionATContact)/tan(rolling_angle*pi/180));   

%% get fake ankle in fix toe coordinate
ankle_z_fore=sin(rolling_angle*pi/180)*m;
ankle_x_fore=cos(rolling_angle*pi/180)*m+(L-m)/(cos(rolling_angle*pi/180));
ankle_y_fore = 0;

%% Equations %%
% change the ankle point in heel axis to toe axis(fixed), and they should be the same
T_toe_heel=[cos(-pi) -sin(-pi) 0 shift_FF_boundary;...
        sin(-pi) cos(-pi) 0 0;...
        0 0 1 0;...
        0 0 0 1];
temp=T_toe_heel*[ankle_x_hind;ankle_y_hind;ankle_z_hind;1];
F(1) = ankle_x_fore-temp(1);
F(2) = ankle_z_hind-ankle_z_fore;
end

