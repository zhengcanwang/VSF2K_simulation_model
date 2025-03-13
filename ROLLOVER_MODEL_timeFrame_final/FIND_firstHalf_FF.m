%% this function calculate from two sides (fore and hind) in stage2_1 (heel-fix) and they should be match
function [F,P_fore,P_hind] = FIND_firstHalf_FF(x,foot_angle_FF,theta_hind_offset,theta_fore_offset,a_fore,a_hind) 
% foot_angle_FF in degree
%% cannot have negative load here!
% explanation on why output "P_hind" (since P_hind=x(1) is actually solved by fsolve, so why?): 
% see explanation in FIND_secondHalf_FF.m. (We just want to have the same format also in stage21!)
if x(1)<0
    x(1)=0;
end

load_hind=x(1);
shift_FF=x(2);

%% The load at this load at this foot angle (and shared by fore and hind foot)
force_angle = ISOAngle2Force(foot_angle_FF*pi/180);
P_hind=load_hind;
P_fore=force_angle-P_hind;

% cannot have negative load here!
if P_fore<0
    P_fore=0;
end

%% For hind foot %%
%% Set the fulcrum position, the load, and the rollingangle for core
a=a_hind;

P=P_hind;

rolling_angle_hind=theta_hind_offset-foot_angle_FF;
rolling_angle=rolling_angle_hind; % in degree

%% start the core for hind foot
[x_contact_new,deflectionATContact]=core(a, rolling_angle, P*cosd(rolling_angle), "hind"); % input in degree, meter, and N

%% Get y or m
HindFoot_design;
y = L-x_contact_new -(-deflectionATContact)/tan(rolling_angle*pi/180); 

%% get fake ankle in fix heel coordinate
ankle_z_hind=sin(rolling_angle*pi/180)*y;
ankle_x_hind=cos(rolling_angle*pi/180)*y+(L-y)/(cos(rolling_angle*pi/180));
ankle_y_hind = 0;

%% Removes all variables from the current workspace except:
clearvars -except foot_angle_FF ankle_z_hind ankle_x_hind ankle_y_hind y x(1) x(2) shift_FF load_hind P_hind P_fore...
                  theta_fore_offset a_fore;

%% For fore foot %%
%% Set the fulcrum position, the load, and the rollingangle for core
a=a_fore;

P=P_fore;

rolling_angle_fore=foot_angle_FF+theta_fore_offset;
rolling_angle=rolling_angle_fore; % in degree

%% start the core for fore foot
[x_contact_new,deflectionATContact]=core(a, rolling_angle, P*cosd(rolling_angle), "fore"); % input in degree, meter, and N

%% Get Y or m
ForeFoot_design;
m = double(L-x_contact_new-(-deflectionATContact)/tan(rolling_angle*pi/180));     

%% get fake ankle in moving toe coordinate
ankle_z_fore=sin(rolling_angle*pi/180)*m;
ankle_x_fore=cos(rolling_angle*pi/180)*m+(L-m)/(cos(rolling_angle*pi/180));
ankle_y_fore = 0;

%% Equations %%
% change the ankle point in toe axis to heel axis(fixed), and they should be the same
T_heel_toe=[cos(pi) -sin(pi) 0 shift_FF;...
        sin(pi) cos(pi) 0 0;...
        0 0 1 0;...
        0 0 0 1];
temp=T_heel_toe*[ankle_x_fore;ankle_y_fore;ankle_z_fore;1];
F(1) = ankle_x_hind-temp(1);
F(2) = ankle_z_hind-ankle_z_fore;
end
