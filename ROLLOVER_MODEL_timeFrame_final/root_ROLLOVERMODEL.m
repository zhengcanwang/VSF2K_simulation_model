clc;clearvars -except ST ALI;close all
ST=16;
% Setup PART 1 2 3, and run!
%% 1. Edit, input, print and plot the design for the keels
% the design can be edited in ForeFoot_design.m and HindFoot_design.m
root1_show_the_design;

%% 2. Edit the keel alignment design, ankle alignment, rolling-angle's offset, and real ankle here (see geometry analysis)
% keel alignment (neutral angles)
% only edit the netural angle for hindfoot (please see geometry analysis)
theta_hind_n=20; % edit here
theta_fore_n=(asin(sin(theta_hind_n*pi/180)/(L_fore/L_hind)))*180/pi; % L_fore and L_hind is inside "show_the_design"
% the length of the whole foot
foot_length=(L_hind*cosd(theta_hind_n)+L_fore*cosd(theta_fore_n))*1000; 

% Length of the real ankle point (from the two keels' merge point， i.e., fake ankle point)
% we set it to be (28% of the foot length) - (the ground to the merge point length)
length_of_realAnkle=0.28*foot_length/1000-(L_hind*sind(theta_hind_n));

% ankle alignment
alignment=3; % edit here

% rolling-angle's offset
theta_hind_offset=theta_hind_n+alignment;
theta_fore_offset=theta_fore_n-alignment; 

%% 3. Edit the fulcrum position for hind-foot and fore-foot
% if you just want to run one setting:
%a_hind= 0.06;%a_max_hind*0.95;
%a_fore = 0.12; %a_max_fore*0.95;

% if you try to run a loop in the terminal:
if ST==1
    a_hind= 0.045;%a_max_hind*0.95; 0.06 0.045 0.03 0.015
    a_fore = 0.09; %a_max_fore*0.95; 0.12 0.09 0.06 0.03
end
if ST==2
    a_hind= 0.03;%a_max_hind*0.95; 0.06 0.045 0.03 0.015
    a_fore = 0.06; %a_max_fore*0.95; 0.12 0.09 0.06 0.03
end
if ST==3
    a_hind= 0.015;%a_max_hind*0.95; 0.06 0.045 0.03 0.015
    a_fore = 0.03; %a_max_fore*0.95; 0.12 0.09 0.06 0.03
end
if ST==4
    a_hind= 0.06;%a_max_hind*0.95; 0.06 0.045 0.03 0.015
    a_fore = 0.09; %a_max_fore*0.95; 0.12 0.09 0.06 0.03
end
if ST==5
    a_hind= 0.06;%a_max_hind*0.95; 0.06 0.045 0.03 0.015
    a_fore = 0.06; %a_max_fore*0.95; 0.12 0.09 0.06 0.03
end
if ST==6
    a_hind= 0.06;%a_max_hind*0.95; 0.06 0.045 0.03 0.015
    a_fore = 0.03; %a_max_fore*0.95; 0.12 0.09 0.06 0.03
end
if ST==7
    a_hind= 0.045;%a_max_hind*0.95; 0.06 0.045 0.03 0.015
    a_fore = 0.12; %a_max_fore*0.95; 0.12 0.09 0.06 0.03
end
if ST==8
    a_hind= 0.045;%a_max_hind*0.95; 0.06 0.045 0.03 0.015
    a_fore = 0.06; %a_max_fore*0.95; 0.12 0.09 0.06 0.03
end
if ST==9
    a_hind= 0.045;%a_max_hind*0.95; 0.06 0.045 0.03 0.015
    a_fore = 0.03; %a_max_fore*0.95; 0.12 0.09 0.06 0.03
end
if ST==10
    a_hind= 0.03;%a_max_hind*0.95; 0.06 0.045 0.03 0.015
    a_fore = 0.12; %a_max_fore*0.95; 0.12 0.09 0.06 0.03
end
if ST==11
    a_hind= 0.03;%a_max_hind*0.95; 0.06 0.045 0.03 0.015
    a_fore = 0.09; %a_max_fore*0.95; 0.12 0.09 0.06 0.03
end
if ST==12
    a_hind= 0.03;%a_max_hind*0.95; 0.06 0.045 0.03 0.015
    a_fore = 0.03; %a_max_fore*0.95; 0.12 0.09 0.06 0.03
end
if ST==13
    a_hind= 0.015;%a_max_hind*0.95; 0.06 0.045 0.03 0.015
    a_fore = 0.12; %a_max_fore*0.95; 0.12 0.09 0.06 0.03
end
if ST==14
    a_hind= 0.015;%a_max_hind*0.95; 0.06 0.045 0.03 0.015
    a_fore = 0.09; %a_max_fore*0.95; 0.12 0.09 0.06 0.03
end
if ST==15
    a_hind= 0.015;%a_max_hind*0.95; 0.06 0.045 0.03 0.015
    a_fore = 0.06; %a_max_fore*0.95; 0.12 0.09 0.06 0.03
end
if ST==16
    a_hind= 0.06;%a_max_hind*0.95; 0.06 0.045 0.03 0.015
    a_fore = 0.12; %a_max_fore*0.95; 0.12 0.09 0.06 0.03
end

%% 4. Initial Setup of the model
root2_Initial_Setup;

%% 5. Through Core of finding x_contact (core.m), find:
% the correct boundary-foot-angles between each stage
root3_solve_boundaryfootAngles;

%% Append for time frame: Identify the stages of the foot angle array in time Frame!
root_append_timeFrame;

%% 6. Through Core of finding x_contact (core.m), find:
% loads for hind/fore foot @ stage2
root4_loadsSHARE_stage2;

%% 7. Through Core of finding x_contact (core.m), simulate:
% all x_contact (COP) for each foot at each stages in undeflected heel/toe coordinate
% all rolling_angle, foot-angle, and loads for each foot at each stages
root5_simulate_all_undeflected;

%% 8. Through Core of animation (core_animation.m), simulate and transform to:
% the real COP, real ankle point, and the deflected keels in heel-FIX coordinate
root6_simulate_all_heelFIX

%% 9. Result Part
% ROS;EFLR; DMAMA; Animation
root7_result;

% the quasi-stiffness
%root_QuasiStiff;

%% 10. For this design: save the ankle alignment, fulcrum position, ROS center, ROS radius,EFLR, DMAMA, etc.
% save all data
fname1 = sprintf('final_all_data_myfile_%.3f_%.3f_alignment_%.3f.mat', a_hind,a_fore,alignment);
save(fname1)

% save the result matrix
save_matrix=[alignment,a_hind*1000,a_fore*1000,center_x,center_z,radius,DMAMA,DMAMA_N,ankle_moment_zero,l_angular,EFLR];
fname2 = sprintf('final_results_myfile_%.3f_%.3f_alignment_%.3f.mat', a_hind,a_fore,alignment);
save(fname2,'save_matrix')