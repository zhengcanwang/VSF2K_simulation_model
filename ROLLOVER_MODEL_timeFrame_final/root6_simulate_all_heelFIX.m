%% set number of sample points in each range                 
n_points=10;

%% Stage1 and Stage2.1 for hindfoot; and Stage1 for forefoot (toe and fulcrum of forefoot)
z_hind_heelUNdeflected=[];
x_hind_heelUNdeflected=[];

z_x_contact_hind_heelUNdeflected=[];
x_x_contact_hind_heelUNdeflected=[];

z_a_hind_heelUNdeflected=[];
x_a_hind_heelUNdeflected=[];

% get the deflected keel in the undeflected heel coordinate
for i=[index_stage1,index_stage21]
    x_contact=x_contact_hind_heelUNdeflected(i); % 3rd input into core
    P=load_hind_allstages(i); % 2nd input into core
    
    % do the core, get the deflection we want
    [deflection_total,xplot_total,deflection_x_contact,xplot_x_contact,deflection_a,xplot_a]...
        =core_animation(a_hind, P*cosd(rollingangle_hind_allstages(i)), x_contact, "hind", n_points);
    
    % get the deflected keel in the undeflected heel coordinate
    z_hind_heelUNdeflected=[z_hind_heelUNdeflected,-deflection_total];
    x_hind_heelUNdeflected=[x_hind_heelUNdeflected,xplot_total];
    
    % get the x_contact of hind foot in the undeflected heel coordinate
    z_x_contact_hind_heelUNdeflected=[z_x_contact_hind_heelUNdeflected,-deflection_x_contact];
    x_x_contact_hind_heelUNdeflected=[x_x_contact_hind_heelUNdeflected,xplot_x_contact];
    
    % get the fulcrum of hind foot in the undeflected heel coordinate
    z_a_hind_heelUNdeflected=[z_a_hind_heelUNdeflected,-deflection_a];
    x_a_hind_heelUNdeflected=[x_a_hind_heelUNdeflected,xplot_a];
end

% do the transformation from undeflected heel coordinate to the heel-fix coordinate
for j=[index_stage1,index_stage21]
    % the transform matrix: heel-fix coordinate to undeflected heel coordinate (See gemotry anaylsis)
    x_shift=sin(rollingangle_hind_allstages(j)*pi/180)*z_hind_heelUNdeflected(1,j);
    z_shift=cos(rollingangle_hind_allstages(j)*pi/180)*z_hind_heelUNdeflected(1,j);
    rotation=rollingangle_hind_allstages(j)*pi/180;
    T_heelFIX_heelUNdeflected=[cos(-rotation) 0 sin(-rotation) x_shift;...
            0               1                  0       0;...
            -sin(-rotation) 0    cos(-rotation) -z_shift;...
            0               0                 0        1];

    % get the deflected keel in the heel-fix coordinate
    for i=1:1:size(z_hind_heelUNdeflected,1)
        temp=T_heelFIX_heelUNdeflected*[x_hind_heelUNdeflected(i,j);0;z_hind_heelUNdeflected(i,j);1];
        x_hind_heelFIX(i,j)=temp(1);
        z_hind_heelFIX(i,j)=temp(3);
    end
    
    % get the x_contact of hind foot in the heel-fix coordinate
    tempp=T_heelFIX_heelUNdeflected*[x_x_contact_hind_heelUNdeflected(j);0;z_x_contact_hind_heelUNdeflected(j);1];
    x_x_contact_hind_heelFIX(j)=tempp(1);
    z_x_contact_hind_heelFIX(j)=tempp(3);
    
    % get the fulcrum of hind foot in the heel-fix coordinate
    tempp=T_heelFIX_heelUNdeflected*[x_a_hind_heelUNdeflected(j);0;z_a_hind_heelUNdeflected(j);1];
    x_a_hind_heelFIX(j)=tempp(1);
    z_a_hind_heelFIX(j)=tempp(3);

    % get the toe in undeflected heel coordinate only in stage 1 (See gemotry anaylsis)
    x_toe_heelUNdeflected=L_hind+L_fore*cos((theta_fore_n+theta_hind_n)*pi/180);
    z_toe_heelUNdeflected=-L_fore*sin((theta_fore_n+theta_hind_n)*pi/180);
    % get the toe in heel-fix coordinate only in stage 1
    tempp=T_heelFIX_heelUNdeflected*[x_toe_heelUNdeflected;0;z_toe_heelUNdeflected;1];
    x_toe_stage1_heelFIX(j)=tempp(1);
    z_toe_stage1_heelFIX(j)=tempp(3);
    
    % get the fulcrum of forefoot in undeflected heel coordinate only in stage 1 (See gemotry anaylsis)
    x_a_fore_stage1_heelUNdeflected=L_hind+(L_fore-a_fore)*cos((theta_fore_n+theta_hind_n)*pi/180);
    z_a_fore_stage1_heelUNdeflected=-(L_fore-a_fore)*sin((theta_fore_n+theta_hind_n)*pi/180);
    % get the fulcrum of forefoot in heel-fix coordinate only in stage 1
    tempp=T_heelFIX_heelUNdeflected*[x_a_fore_stage1_heelUNdeflected;0;z_a_fore_stage1_heelUNdeflected;1];
    x_a_fore_stage1_heelFIX(j)=tempp(1);
    z_a_fore_stage1_heelFIX(j)=tempp(3);

    % get the real ankle in undeflected heel coordinate in stage 1 and 2.1(See gemotry anaylsis)
    x_ankleReal_heelUNdeflected=L_hind+length_of_realAnkle*cos((-foot_angle_allstages(j)+(90-rollingangle_hind_allstages(j))+alignment)*pi/180);
    z_ankleReal_heelUNdeflected=length_of_realAnkle*sin((-foot_angle_allstages(j)+(90-rollingangle_hind_allstages(j))+alignment)*pi/180);
    % get the real ankle in heel-fix coordinate in stage 1 and 2.1
    tempp=T_heelFIX_heelUNdeflected*[x_ankleReal_heelUNdeflected;0;z_ankleReal_heelUNdeflected;1];
    x_ankleReal_heelFIX(j)=tempp(1);
    z_ankleReal_heelFIX(j)=tempp(3);
end

%% Stage 2.2 for hindfoot
% get the deflected keel in the undeflected heel coordinate
for i=index_stage22
    x_contact=x_contact_hind_heelUNdeflected(i); % 3rd input into core
    P=load_hind_allstages(i); % 2nd input into core
    
    % do the core, get the deflection we want
    [deflection_total,xplot_total,deflection_x_contact,xplot_x_contact,deflection_a,xplot_a]...
        =core_animation(a_hind, P*cosd(rollingangle_hind_allstages(i)), x_contact, "hind", n_points);
    
    % get the deflected keel in the undeflected heel coordinate
    z_hind_heelUNdeflected=[z_hind_heelUNdeflected,-deflection_total];
    x_hind_heelUNdeflected=[x_hind_heelUNdeflected,xplot_total];
    
    % get the x_contact of hind foot in the undeflected heel coordinate
    z_x_contact_hind_heelUNdeflected=[z_x_contact_hind_heelUNdeflected,-deflection_x_contact];
    x_x_contact_hind_heelUNdeflected=[x_x_contact_hind_heelUNdeflected,xplot_x_contact];
    
    % get the fulcrum of hind foot in the undeflected heel coordinate
    z_a_hind_heelUNdeflected=[z_a_hind_heelUNdeflected,-deflection_a];
    x_a_hind_heelUNdeflected=[x_a_hind_heelUNdeflected,xplot_a];
end

% do the transformation from undeflected heel coordinate to the heel-move coordinate and then to the heel-fix coordinate
for j=index_stage22
    % the transform matrix: heel-move coordinate to undeflected heel coordinate (See gemotry anaylsis)
    x_shift=sin(rollingangle_hind_allstages(j)*pi/180)*z_hind_heelUNdeflected(1,j);
    z_shift=cos(rollingangle_hind_allstages(j)*pi/180)*z_hind_heelUNdeflected(1,j);
    rotation=rollingangle_hind_allstages(j)*pi/180;
    T_heelMOVED_heelUNdeflected=[cos(-rotation) 0 sin(-rotation) x_shift;...
            0               1                  0       0;...
            -sin(-rotation) 0    cos(-rotation) -z_shift;...
            0               0                 0        1];

    % the transform matrix: heel-fix coordinate to heel-move coordinate (the heel start to move forward; the toe becomes fix)
    % toe starts to fix at this shift "shift_FF_boundary"!
    % "SS_stage2(j-length(foot_angle_stage1),4)" is the shift (distance between toe and heel) after mid of stage2
    % "shift_FF_boundary" is the shift (distance between toe and heel) at mid of stage2 (where: toe starts to fix)
    % the difference between them are the samll drift of the heel
    x_shift_=shift_FF_boundary-SS_stage2(j-length(foot_angle_stage1),4); 
    T_heelFIX_heelMOVED=[1 0 0 x_shift_;...
            0 1 0 0;...
            0 0 1 0;...
            0 0 0 1];

    % get the deflected keel in the heel-fix coordinate
    for i=1:1:size(z_hind_heelUNdeflected,1)
        temp=T_heelFIX_heelMOVED*T_heelMOVED_heelUNdeflected*[x_hind_heelUNdeflected(i,j);0;z_hind_heelUNdeflected(i,j);1];
        x_hind_heelFIX(i,j)=temp(1);
        z_hind_heelFIX(i,j)=temp(3);
    end
    
    % get the x_contact of hind foot in the heel-fix coordinate
    tempp=T_heelFIX_heelMOVED*T_heelMOVED_heelUNdeflected*[x_x_contact_hind_heelUNdeflected(j);0;z_x_contact_hind_heelUNdeflected(j);1];
    x_x_contact_hind_heelFIX(j)=tempp(1);
    z_x_contact_hind_heelFIX(j)=tempp(3);
    
    % get the fulcrum of hind foot in the heel-fix coordinate
    tempp=T_heelFIX_heelMOVED*T_heelMOVED_heelUNdeflected*[x_a_hind_heelUNdeflected(j);0;z_a_hind_heelUNdeflected(j);1];
    x_a_hind_heelFIX(j)=tempp(1);
    z_a_hind_heelFIX(j)=tempp(3);
end

%% stage 2.1 for forefoot
% make sure the stage1 columns are all zeros
z_fore_toeUNdeflected=zeros(size(z_hind_heelUNdeflected,1),length(foot_angle_stage1)); % make sure the stage 1 columns are all zeros
x_fore_toeUNdeflected=zeros(size(z_hind_heelUNdeflected,1),length(foot_angle_stage1)); % make sure the stage 1 columns are all zeros

z_x_contact_fore_toeUNdeflected=zeros(1,length(foot_angle_stage1)); % make sure the stage 1 columns are all zeros
x_x_contact_fore_toeUNdeflected=zeros(1,length(foot_angle_stage1)); % make sure the stage 1 columns are all zeros

z_a_fore_toeUNdeflected=zeros(1,length(foot_angle_stage1)); % make sure the stage 1 columns are all zeros
x_a_fore_toeUNdeflected=zeros(1,length(foot_angle_stage1)); % make sure the stage 1 columns are all zeros

% get the deflected keel in the undeflected toe coordinate
for i=index_stage21
    x_contact=x_contact_fore_toeUNdeflected(i); % 3rd input into core
    P=load_fore_allstages(i); % 2nd input into core
    
    % do the core, get the deflection we want
    [deflection_total,xplot_total,deflection_x_contact,xplot_x_contact,deflection_a,xplot_a]...
        =core_animation(a_fore, P*cosd(rollingangle_fore_allstages(i)), x_contact, "fore", n_points);
    
    % get the deflected keel in the undeflected toe coordinate
    z_fore_toeUNdeflected=[z_fore_toeUNdeflected,-deflection_total];
    x_fore_toeUNdeflected=[x_fore_toeUNdeflected,xplot_total];
    
    % get the x_contact of fore foot in the undeflected toe coordinate
    z_x_contact_fore_toeUNdeflected=[z_x_contact_fore_toeUNdeflected,-deflection_x_contact];
    x_x_contact_fore_toeUNdeflected=[x_x_contact_fore_toeUNdeflected,xplot_x_contact];
    
    % get the fulcrum of fore foot in the undeflected toe coordinate
    z_a_fore_toeUNdeflected=[z_a_fore_toeUNdeflected,-deflection_a];
    x_a_fore_toeUNdeflected=[x_a_fore_toeUNdeflected,xplot_a];
end

% do the transformation from undeflected toe coordinate to the toe-move coordinate and then to the heel-fix coordinate
for j=index_stage21
    % the transform matrix: toe-move coordinate to undeflected toe coordinate (See gemotry anaylsis)
    x_shift=sin(rollingangle_fore_allstages(j)*pi/180)*z_fore_toeUNdeflected(1,j);
    z_shift=cos(rollingangle_fore_allstages(j)*pi/180)*z_fore_toeUNdeflected(1,j);
    rotation=rollingangle_fore_allstages(j)*pi/180;
    T_toeMOVED_toeUNdeflected=[cos(-rotation) 0 sin(-rotation) x_shift;...
            0               1                  0       0;...
            -sin(-rotation) 0    cos(-rotation) -z_shift;...
            0               0                 0        1];

    % the transform matrix: heel-fix coordinate to toe-move coordinate (the toe start to move forward; the heel is fix)
    % "SS_stage2(j-length(foot_angle_stage1),4)" is the shift (distance between toe and heel) in the first half of stage2
    x_shift_=SS_stage2(j-length(foot_angle_stage1),4);
    T_heelFIX_toeMOVED=[cos(pi) -sin(pi) 0 x_shift_;...
            sin(pi) cos(pi) 0 0;...
            0 0 1 0;...
            0 0 0 1];

    % get the deflected keel in the heel-fix coordinate
    for i=1:1:size(z_fore_toeUNdeflected,1)
        temp=T_heelFIX_toeMOVED*T_toeMOVED_toeUNdeflected*[x_fore_toeUNdeflected(i,j);0;z_fore_toeUNdeflected(i,j);1];
        x_fore_heelFIX(i,j)=temp(1);
        z_fore_heelFIX(i,j)=temp(3);
    end
    
    % get the x_contact of fore foot in the heel-fix coordinate
    tempp=T_heelFIX_toeMOVED*T_toeMOVED_toeUNdeflected*[x_x_contact_fore_toeUNdeflected(j);0;z_x_contact_fore_toeUNdeflected(j);1];
    x_x_contact_fore_heelFIX(j)=tempp(1);
    z_x_contact_fore_heelFIX(j)=tempp(3);
    
    % get the fulcrum of fore foot in the heel-fix coordinate
    tempp=T_heelFIX_toeMOVED*T_toeMOVED_toeUNdeflected*[x_a_fore_toeUNdeflected(j);0;z_a_fore_toeUNdeflected(j);1];
    x_a_fore_heelFIX(j)=tempp(1);
    z_a_fore_heelFIX(j)=tempp(3);
end

%% stage 2.2 and stage 3 for forefoot
for i=[index_stage22,index_stage3]
    x_contact=x_contact_fore_toeUNdeflected(i); % 3rd input into core
    P=load_fore_allstages(i); % 2nd input into core
    
    % do the core, get the deflection we want
    [deflection_total,xplot_total,deflection_x_contact,xplot_x_contact,deflection_a,xplot_a]...
        =core_animation(a_fore, P*cosd(rollingangle_fore_allstages(i)), x_contact, "fore", n_points);
    
    % get the deflected keel in the undeflected toe coordinate
    z_fore_toeUNdeflected=[z_fore_toeUNdeflected,-deflection_total];
    x_fore_toeUNdeflected=[x_fore_toeUNdeflected,xplot_total];
    
    % get the x_contact of fore foot in the undeflected toe coordinate
    z_x_contact_fore_toeUNdeflected=[z_x_contact_fore_toeUNdeflected,-deflection_x_contact];
    x_x_contact_fore_toeUNdeflected=[x_x_contact_fore_toeUNdeflected,xplot_x_contact];
    
    % get the fulcrum of fore foot in the undeflected toe coordinate
    z_a_fore_toeUNdeflected=[z_a_fore_toeUNdeflected,-deflection_a];
    x_a_fore_toeUNdeflected=[x_a_fore_toeUNdeflected,xplot_a];
end

% do the transformation from undeflected toe coordinate to the toe-fix coordinate, and then to the heel-fix coordinate
for j=[index_stage22,index_stage3]
    % the transform matrix: toe-fix coordinate to undeflected toe coordinate (See gemotry anaylsis)
    x_shift=sin(rollingangle_fore_allstages(j)*pi/180)*z_fore_toeUNdeflected(1,j);
    z_shift=cos(rollingangle_fore_allstages(j)*pi/180)*z_fore_toeUNdeflected(1,j);
    rotation=rollingangle_fore_allstages(j)*pi/180;
    T_toeFIX_toeUNdeflected=[cos(-rotation) 0 sin(-rotation) x_shift;...
            0               1                  0       0;...
            -sin(-rotation) 0    cos(-rotation) -z_shift;...
            0               0                 0        1];

    % the transform matrix: heel-fix coordinate to toe-fix coordinate
    % "shift_FF_boundary" is the shift (distance between fix-toe and fix-heel) at the mid of stage 2
    x_shift_=shift_FF_boundary;
    T_heelFIX_toeFIX=[cos(pi) -sin(pi) 0 x_shift_;...
            sin(pi) cos(pi) 0 0;...
            0 0 1 0;...
            0 0 0 1];

    % get the x_contact of hind foot in the heel-fix coordinate
    for i=1:1:size(z_hind_heelUNdeflected,1)
        temp=T_heelFIX_toeFIX*T_toeFIX_toeUNdeflected*[x_fore_toeUNdeflected(i,j);0;z_fore_toeUNdeflected(i,j);1];
        x_fore_heelFIX(i,j)=temp(1);
        z_fore_heelFIX(i,j)=temp(3);
    end
    
    % get the x_contact of fore foot in the heel-fix coordinate
    tempp=T_heelFIX_toeFIX*T_toeFIX_toeUNdeflected*[x_x_contact_fore_toeUNdeflected(j);0;z_x_contact_fore_toeUNdeflected(j);1];
    x_x_contact_fore_heelFIX(j)=tempp(1);
    z_x_contact_fore_heelFIX(j)=tempp(3);
    
    % get the fulcrum of fore foot in the heel-fix coordinate
    tempp=T_heelFIX_toeFIX*T_toeFIX_toeUNdeflected*[x_a_fore_toeUNdeflected(j);0;z_a_fore_toeUNdeflected(j);1];
    x_a_fore_heelFIX(j)=tempp(1);
    z_a_fore_heelFIX(j)=tempp(3);

    % get the heel in undeflected heel coordinate only in stage 3 (See gemotry anaylsis)
    x_heel_toeUNdeflected=L_fore+L_hind*cos((theta_fore_n+theta_hind_n)*pi/180);
    z_heel_toeUNdeflected=-L_hind*sin((theta_fore_n+theta_hind_n)*pi/180);
    % get the heel in heel-fix coordinate only in stage 3
    tempp=T_heelFIX_toeFIX*T_toeFIX_toeUNdeflected*[x_heel_toeUNdeflected;0;z_heel_toeUNdeflected;1];
    x_heel_stage3_heelFIX(j)=tempp(1);
    z_heel_stage3_heelFIX(j)=tempp(3);
    
    % get the fulcrum of hindfoot in undeflected toe coordinate only in stage 3 (See gemotry anaylsis)
    x_a_hind_stage3_heelUNdeflected=L_fore+(L_hind-a_hind)*cos((theta_fore_n+theta_hind_n)*pi/180);
    z_a_hind_stage3_heelUNdeflected=-(L_hind-a_hind)*sin((theta_fore_n+theta_hind_n)*pi/180);    
    % get the fulcrum of hindfoot in heel-fix coordinate only in stage 3
    tempp=T_heelFIX_toeFIX*T_toeFIX_toeUNdeflected*[x_a_hind_stage3_heelUNdeflected;0;z_a_hind_stage3_heelUNdeflected;1];
    x_a_hind_stage3_heelFIX(j)=tempp(1);
    z_a_hind_stage3_heelFIX(j)=tempp(3);

    % get the real ankle in undeflected toe coordinate in stage 2.2 and 3(See gemotry anaylsis)
    x_ankleReal_heelUNdeflected=L_fore+length_of_realAnkle*cos((foot_angle_allstages(j)+(90-rollingangle_fore_allstages(j))-alignment)*pi/180);
    z_ankleReal_heelUNdeflected=length_of_realAnkle*sin((foot_angle_allstages(j)+(90-rollingangle_fore_allstages(j))-alignment)*pi/180);
    % get the real ankle in heel-fix coordinate in stage 2.2 and 3(See gemotry anaylsis)
    tempp=T_heelFIX_toeFIX*T_toeFIX_toeUNdeflected*[x_ankleReal_heelUNdeflected;0;z_ankleReal_heelUNdeflected;1];
    x_ankleReal_heelFIX(j)=tempp(1);
    z_ankleReal_heelFIX(j)=tempp(3);
end

%% Finally, the real COP for hindfoot, forefoot, and total
% hind foot: Stage 1 2.1 2.2 (ignore the stage 3)
COP_hind_heelFIX= [x_x_contact_hind_heelFIX,nan(1,length(foot_angle_stage3))];
% fore foot: Stage 2.1 2.2 3 (ignore the stage 1)
COP_fore_heelFIX= [nan(1,length(foot_angle_stage1)),x_x_contact_fore_heelFIX([index_stage21,index_stage22,index_stage3])];
% the total REAL COP! (weighted mean in Stage2)
COP_heelFIX = ...
[COP_hind_heelFIX(index_stage1),...
(load_hind_stage21.*COP_hind_heelFIX(index_stage21)+load_fore_stage21.*COP_fore_heelFIX(index_stage21))./load_total_allstages(index_stage21),...
(load_hind_stage22.*COP_hind_heelFIX(index_stage22)+load_fore_stage22.*COP_fore_heelFIX(index_stage22))./load_total_allstages(index_stage22),...
COP_fore_heelFIX(index_stage3)];

%% Finally, the real ankle points for all stages in heelFIX coordinate!
ankle_x_heelFIX=x_ankleReal_heelFIX;
ankle_z_heelFIX=z_ankleReal_heelFIX;