clc;clear;close all
%% 1. Edit, input, print and plot the design for the keels
% the design can be edited in ForeFoot_design.m and HindFoot_design.m
root1_show_the_design;

%% 2. input the netural angle for hindfoot (please see geometry analysis)
theta_hind_n=20; % edit here
theta_fore_n=(asin(sin(theta_hind_n*pi/180)/(L_fore/L_hind)))*180/pi; % L_fore and L_hind is inside "show_the_design"

%% 3. run the linear stiffness evaluation:
[k1_hind,k2_hind,k3_hind,k4_hind,k5_hind,k6_hind,a_hind]=linearStiffnessModel(theta_hind_n, 'hind');
[k1_fore,k2_fore,k3_fore,k4_fore,k5_fore,k6_fore,a_fore]=linearStiffnessModel(theta_fore_n, 'fore');

%% 4. save the stiffness into matrix:
hind_linear_stiff=[a_hind'*1000,k1_hind',k2_hind',k3_hind',k4_hind',k5_hind',k6_hind'];
fore_linear_stiff=[a_fore'*1000,k1_fore',k2_fore',k3_fore',k4_fore',k5_fore',k6_fore'];
save('hind_linear_stiffness','hind_linear_stiff');
save('fore_linear_stiffness','fore_linear_stiff');
