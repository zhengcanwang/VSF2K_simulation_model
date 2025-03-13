%% get the real ankle position during all stages
x_ankleReal_heelFIX;
z_ankleReal_heelFIX;

%% get the fake ankle position during all stages
x_ankleFake_heelFIX=[x_hind_heelFIX(end,[index_stage1,index_stage21,index_stage22]),x_fore_heelFIX(end,index_stage3)];
z_ankleFake_heelFIX=[z_hind_heelFIX(end,[index_stage1,index_stage21,index_stage22]),z_fore_heelFIX(end,index_stage3)];

%% get the contact point of hindfoot of all stages (include heel of stage3)
x_contact_QuasiK_hind=[COP_hind_heelFIX([index_stage1,index_stage21,index_stage22]),x_heel_stage3_heelFIX(index_stage3)];
z_contact_QuasiK_hind=[zeros(1,length([index_stage1,index_stage21,index_stage22])),z_heel_stage3_heelFIX(index_stage3)];

%x_contact_QuasiK_hind=[zeros(1,length([index_stage1,index_stage21])),x_hind_heelFIX(1,index_stage22),x_heel_stage3_heelFIX(index_stage3)];
%z_contact_QuasiK_hind=[zeros(1,length([index_stage1,index_stage21,index_stage22])),z_heel_stage3_heelFIX(index_stage3)];

%% get the contact point of forefoot of all stages (include toe of stage1)
x_contact_QuasiK_fore=[x_toe_stage1_heelFIX(index_stage1),COP_fore_heelFIX([index_stage21,index_stage22,index_stage3])];
z_contact_QuasiK_fore=[z_toe_stage1_heelFIX(index_stage1),zeros(1,length([index_stage21,index_stage22,index_stage3]))];

%x_contact_QuasiK_fore=[x_toe_stage1_heelFIX(index_stage1),x_fore_heelFIX(1,index_stage21),x_fore_heelFIX(1,index_stage22(1))*ones(1,length([index_stage22,index_stage3]))];
%z_contact_QuasiK_fore=[z_toe_stage1_heelFIX(index_stage1),zeros(1,length([index_stage21,index_stage22,index_stage3]))];

%% get the relative ankle angle at each foot angle:
slope_foot=(z_contact_QuasiK_fore-z_contact_QuasiK_hind)./(x_contact_QuasiK_fore-x_contact_QuasiK_hind);
slopeAngle_foot=atand(slope_foot);

slope_ankleBar=(z_ankleReal_heelFIX-z_ankleFake_heelFIX)./(x_ankleReal_heelFIX-x_ankleFake_heelFIX);
slopeAngle_ankleBar=atand(slope_ankleBar);

for i=1:1:length(slopeAngle_ankleBar)
% condition one and two: (please see geometry analysis)
if (slopeAngle_ankleBar(i)<0 && slopeAngle_foot(i)>=0) || (slopeAngle_ankleBar(i)<0 && slopeAngle_foot(i)<0)
    relative_ankle(i)=180-slopeAngle_foot(i)+slopeAngle_ankleBar(i);
end

% condition three and four: (please see geometry analysis)
if (slopeAngle_ankleBar(i)>0 && slopeAngle_foot(i)<0) || (slopeAngle_ankleBar(i)>0 && slopeAngle_foot(i)>=0)
    relative_ankle(i)=slopeAngle_ankleBar(i)-slopeAngle_foot(i);
end
end

%% plot the ankle moment vs relative ankle angle:
figure
for i=1:1:length(slopeAngle_ankleBar)
    if i<=index_stage1(end)
        plot(relative_ankle(i)-90,ankle_moment(i)/1000,'.r');hold on
    end
    if i>=index_stage3(1)
        plot(relative_ankle(i)-90,ankle_moment(i)/1000,'.b');hold on
    end
    if i<index_stage3(1) && i>index_stage1(end)
        plot(relative_ankle(i)-90,ankle_moment(i)/1000,'.g');hold on
    end

    xlabel('Relative Ankle Angle (degree)')
    ylabel('Ankle Moment')
    %pause(0.1)
end
