%% Below is the function to find the end of Foot-Flat info
function [F,m] = FIND_ENDFootFlat_angles(x,theta_hind_offset,theta_fore_offset,a_fore)
%% two unknown (see gemotry analysis)
theta_foot_FF_END=x(1); % theta_foot is just the foot_angle % in rad
theta_heel_FF=x(2); % theta_foot is just the foot_angle

%% First input to core: set the fulcrum position
a=a_fore;

%% Second input to core: load at this foot angle
P = ISOAngle2Force(theta_foot_FF_END);

%% Third input to core: set up the rollingangle for hindFoot at the start of the Foot-Flat (see gemotry analysis)
theta_hind_offset_rad=theta_hind_offset*pi/180;
theta_fore_offset_rad=theta_fore_offset*pi/180;

rolling_angle_ATendFootFlat = theta_fore_offset_rad+theta_foot_FF_END;
rolling_angle = rolling_angle_ATendFootFlat*180/pi; % switch back to degree (it will be converted in "core_b_constant")

%% start the core
[x_contact_new,deflectionATContact]=core(a, rolling_angle, P*cosd(rolling_angle), "fore"); % input in degree, meter, and N

%% Get m after core(see gemotry analysis)
ForeFoot_design;
m = double(L-x_contact_new-(-deflectionATContact)/tan(rolling_angle*pi/180));

%% two Equations (see gemotry analysis)
HindFoot_design; % we need L be the length of hindfoot here!

F(1) = sin(theta_heel_FF)/sin(theta_fore_offset_rad+theta_foot_FF_END)-m/L;
F(2) = theta_heel_FF+theta_foot_FF_END-theta_hind_offset_rad;
end