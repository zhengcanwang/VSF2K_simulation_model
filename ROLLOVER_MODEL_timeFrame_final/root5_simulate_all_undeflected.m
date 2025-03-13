%% Before going Stage1, set the load at each rolling angle
% foot-angle array for stage1
foot_angle_stage1; % get from root_append_timeFrame

% rolling-angle array for hind-foot for stage1
rollingangle_hind_stage1 = interp1([foot_angle_veryInitial,footangle_FF_start],[theta_hind_offset-foot_angle_veryInitial,theta_hind_offset-footangle_FF_start],foot_angle_stage1);

% load profile
load_hind_stage1=zeros(1,length(foot_angle_stage1));
for i=1:1:length(foot_angle_stage1)
    load_hind_stage1(i) = ISOAngle2Force(foot_angle_stage1(i)*pi/180);
end

%% Before going Stage2.1 for hindfoot: setup the load and the rollingangle for hind foot
foot_angle_stage21 = SS_stage2(index_stage21-length(foot_angle_stage1),1)';
load_hind_stage21 = SS_stage2(index_stage21-length(foot_angle_stage1),5)';
rollingangle_hind_stage21=SS_stage2(index_stage21-length(foot_angle_stage1),2)';

%% Before going Stage2.2 for hindfoot: setup the load and the rollingangle for hind foot
foot_angle_stage22 = SS_stage2(index_stage22-length(foot_angle_stage1),1)';
load_hind_stage22 = SS_stage2(index_stage22-length(foot_angle_stage1),5)';
rollingangle_hind_stage22 = SS_stage2(index_stage22-length(foot_angle_stage1),2)';

%% Before going Stage2.1 for forefoot: setup the load and the rollingangle for fore foot
load_fore_stage21=SS_stage2(index_stage21-length(foot_angle_stage1),6)';
rollingangle_fore_stage21=SS_stage2(index_stage21-length(foot_angle_stage1),3)';

%% Before going Stage2.2 for forefoot: setup the load and the rollingangle for fore foot
load_fore_stage22=SS_stage2(index_stage22-length(foot_angle_stage1),6)';
rollingangle_fore_stage22=SS_stage2(index_stage22-length(foot_angle_stage1),3)';

%% Before going StageThree for forefoot: setup the load and the rollingangle for fore foot
% foot-angle for stage3
foot_angle_stage3;% get from root_append_timeFrame

% rolling-angle for fore-foot for stage3
rollingangle_fore_stage3 = interp1([footangle_FF_END,foot_angle_veryEnd],[footangle_FF_END+theta_fore_offset,foot_angle_veryEnd+theta_fore_offset],foot_angle_stage3);

% load profile
load_fore_stage3=zeros(1,length(foot_angle_stage3));
for i=1:1:length(foot_angle_stage3)
    load_fore_stage3(i) = ISOAngle2Force(foot_angle_stage3(i)*pi/180);
end
load_fore_stage3(end)=0;

%% Foot_angle, rollingangle, load for all stages
foot_angle_allstages=[foot_angle_stage1,foot_angle_stage21,foot_angle_stage22,foot_angle_stage3];
rollingangle_hind_allstages=[rollingangle_hind_stage1,rollingangle_hind_stage21,rollingangle_hind_stage22,zeros(1,length(foot_angle_stage3))];
rollingangle_fore_allstages=[zeros(1,length(foot_angle_stage1)),rollingangle_fore_stage21,rollingangle_fore_stage22,rollingangle_fore_stage3];
load_hind_allstages=[load_hind_stage1,load_hind_stage21,load_hind_stage22,zeros(1,length(foot_angle_stage3))];
load_fore_allstages=[zeros(1,length(foot_angle_stage1)),load_fore_stage21,load_fore_stage22,load_fore_stage3];
load_total_allstages=load_hind_allstages+load_fore_allstages;

%% Get all x_contact in the not deflected coordinate:
x_contact_hind_heelUNdeflected=zeros(1,length(foot_angle_allstages));
x_contact_fore_toeUNdeflected=zeros(1,length(foot_angle_allstages));
for i=1:1:length(foot_angle_allstages)
    % hind foot:
    [x_contact_hind_heelUNdeflected(i),~]=core(a_hind, rollingangle_hind_allstages(i), load_hind_allstages(i)*cosd(rollingangle_hind_allstages(i)), "hind");
    % fore foot:
    [x_contact_fore_toeUNdeflected(i),~]=core(a_fore, rollingangle_fore_allstages(i), load_fore_allstages(i)*cosd(rollingangle_fore_allstages(i)), "fore");
end