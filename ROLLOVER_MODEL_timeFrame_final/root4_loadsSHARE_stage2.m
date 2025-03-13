%% At StageTwo: find the rollingangles @ each P_load combinations!
% first column is the foot angle; 
% second column is the rolling angle for hindFoot; 
% third column is the rolling angle for foreFoot; 
% forth column is the shift (distance between toe and the heel)
% fifth column is the load for hindfoot 
% sixth column is the load for forefoot 
% seventh column is the total load

SS_stage2=[];
for footangle_index=foot_angle_stage21 % get from root_append_timeFrame
    SS_1_temp=fsolve(@(x) FIND_firstHalf_FF(x,footangle_index,theta_hind_offset,theta_fore_offset,a_fore,a_hind),[450,300/1000],option);
    [~,load_fore_temp,load_hind_temp]=FIND_firstHalf_FF([SS_1_temp(1),SS_1_temp(2)],footangle_index,theta_hind_offset,theta_fore_offset,a_fore,a_hind); %get load for forefoot
    SS_stage2=[SS_stage2;[footangle_index,theta_hind_offset-footangle_index,footangle_index+theta_fore_offset,SS_1_temp(2),load_hind_temp,load_fore_temp,load_hind_temp+load_fore_temp]];
end
for footangle_index=foot_angle_stage22 % get from root_append_timeFrame
    SS_2_temp=fsolve(@(x) FIND_secondHalf_FF(x,footangle_index,theta_hind_offset,theta_fore_offset,a_fore,a_hind),[150,300/1000],option);
    [~,load_fore_temp,load_hind_temp]=FIND_secondHalf_FF([SS_2_temp(1),SS_2_temp(2)],footangle_index,theta_hind_offset,theta_fore_offset,a_fore,a_hind); %get load for forefoot
    SS_stage2=[SS_stage2;[footangle_index,theta_hind_offset-footangle_index,footangle_index+theta_fore_offset,SS_2_temp(2),load_hind_temp,load_fore_temp,load_hind_temp+load_fore_temp]];
end