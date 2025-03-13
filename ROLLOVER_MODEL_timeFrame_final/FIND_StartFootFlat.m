%% Below is the function to find the start of Foot-Flat info
function [F,y] = FIND_StartFootFlat(x,theta_hind_offset,theta_fore_offset,a_hind)
%% two unknown (see gemotry analysis)
theta_foot_FF_START=x(1); % theta_foot is just the foot_angle % in rad
theta_toe_FF=x(2); % theta_foot is just the foot_angle

%% First input to core: set the fulcrum position
a=a_hind; 

%% Second input to core: load at this foot angle
P = ISOAngle2Force(theta_foot_FF_START);

%% Third input to core: set up the rolling_angle for hindFoot at the start of the Foot-Flat (see gemotry analysis)
theta_hind_offset_rad=theta_hind_offset*pi/180; % Just change to radians
theta_fore_offset_rad=theta_fore_offset*pi/180;

rolling_angle_ATStartFootFlat = theta_hind_offset_rad-theta_foot_FF_START;
rolling_angle = rolling_angle_ATStartFootFlat*180/pi; % switch back to degree (it will be converted in "core")

%% start the core
% input the load, the rolling_angle, and the fulcrum position
[x_contact_new,deflectionATContact]=core(a, rolling_angle, P*cosd(rolling_angle), "hind"); % input in degree, meter, and N

%% Get y after core(see gemotry analysis)
HindFoot_design;
y = L-x_contact_new -(-deflectionATContact)/tan(rolling_angle*pi/180);    

%% two Equations (see gemotry analysis)
ForeFoot_design; % we need L be the length of forefoot here!

F(1) = sin(theta_toe_FF)/sin(theta_hind_offset_rad-theta_foot_FF_START)-y/L;
F(2) = theta_fore_offset_rad-theta_toe_FF+theta_foot_FF_START;
end

