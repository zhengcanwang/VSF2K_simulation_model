%% Identify the stages of the foot angle array
foot_angle_stage1=[];
foot_angle_stage21=[];
foot_angle_stage22=[];
foot_angle_stage3=[];
for i=1:1:length(foot_angle_array_timeFrame)
    % find the foot angles in stage1
    if foot_angle_array_timeFrame(i)>=foot_angle_veryInitial && foot_angle_array_timeFrame(i)<=footangle_FF_start
        foot_angle_stage1=[foot_angle_stage1,foot_angle_array_timeFrame(i)];
    end
    
    % find the foot angles in stage2.1
    if foot_angle_array_timeFrame(i)>=footangle_FF_start && foot_angle_array_timeFrame(i)<=footangle_FF_boundary
        foot_angle_stage21=[foot_angle_stage21,foot_angle_array_timeFrame(i)];
    end
    
    % find the foot angles in stage2.2
    if foot_angle_array_timeFrame(i)>=footangle_FF_boundary && foot_angle_array_timeFrame(i)<=footangle_FF_END
        foot_angle_stage22=[foot_angle_stage22,foot_angle_array_timeFrame(i)];
    end
    
    % find the foot angles in stage3
    if foot_angle_array_timeFrame(i)>=footangle_FF_END && foot_angle_array_timeFrame(i)<=foot_angle_veryEnd
        foot_angle_stage3=[foot_angle_stage3,foot_angle_array_timeFrame(i)];
    end
end

%% indexing for each stages:
index_stage1=1:1:length(foot_angle_stage1);
index_stage21=(1+length(foot_angle_stage1)):1:(length(foot_angle_stage1)+length(foot_angle_stage21));
index_stage22=(1+length(foot_angle_stage1)+length(foot_angle_stage21)):1:(length(foot_angle_stage1)+length(foot_angle_stage21)+length(foot_angle_stage22));
index_stage3=(1+length(foot_angle_stage1)+length(foot_angle_stage21)+length(foot_angle_stage22)):1:(length(foot_angle_array_timeFrame));