%% Summary for all matrix or arrays for the animation! if n_angle=17
%% in stage 1:
% for hind foot: x_hind_heelFIX(:,1:17) ; z_hind_heelFIX(:,1:17)
% for hind foot heel point: x_hind_heelFIX(1,1:17) ; z_hind_heelFIX(1,1:17)
% for hind foot fulcrum point: x_a_hind_heelFIX(1:17) ; z_a_hind_heelFIX(1:17)
% for hind foot contact point: x_x_contact_hind_heelFIX(1:17) ; z_x_contact_hind_heelFIX(1:17)
%
% for fore foot toe point:  x_toe_stage1_heelFIX(1:17) ; z_toe_stage1_heelFIX(1:17)
% for fore foot fulcrum point:  x_a_fore_stage1_heelFIX(1:17) ; z_a_fore_stage1_heelFIX(1:17)
%
% for fake ankle: x_hind_heelFIX(end,1:17) ; z_hind_heelFIX(end,1:17)
% for real ankle: x_ankleReal_heelFIX(1:17) ; z_ankleReal_heelFIX(1:17)

%% in stage 2.1:
% for hind foot: x_hind_heelFIX(:,18:34) ; z_hind_heelFIX(:,18:34)
% for hind foot heel point: x_hind_heelFIX(1,18:34) ; z_hind_heelFIX(1,18:34)
% for hind foot fulcrum point: x_a_hind_heelFIX(18:34) ; z_a_hind_heelFIX(18:34)
% for hind foot contact point: x_x_contact_hind_heelFIX(18:34) ; z_x_contact_hind_heelFIX(18:34)
%
% for fore foot: x_fore_heelFIX(:,18:34) ; z_fore_heelFIX(:,18:34)
% for fore foot toe point: x_fore_heelFIX(1,18:34) ; z_fore_heelFIX(1,18:34)
% for fore foot fulcrum point:  x_a_fore_heelFIX(18:34) ; z_a_fore_heelFIX(18:34)
% for fore foot contact point: x_x_contact_fore_heelFIX(18:34) ; z_x_contact_fore_heelFIX(18:34)
%
% for fake ankle: x_hind_heelFIX(end,18:34) ; z_hind_heelFIX(end,18:34)
% for real ankle: x_ankleReal_heelFIX(18:34) ; z_ankleReal_heelFIX(18:34)

%% in stage 2.2:
% for hind foot: x_hind_heelFIX(:,35:51) ; z_hind_heelFIX(:,35:51)
% for hind foot heel point: x_hind_heelFIX(1,35:51) ; z_hind_heelFIX(1,35:51)
% for hind foot fulcrum point: x_a_hind_heelFIX(35:51) ; z_a_hind_heelFIX(35:51)
% for hind foot contact point: x_x_contact_hind_heelFIX(35:51) ; z_x_contact_hind_heelFIX(35:51)
%
% for fore foot: x_fore_heelFIX(:,35:51) ; z_fore_heelFIX(:,35:51)
% for fore foot toe point: x_fore_heelFIX(1,35:51) ; z_fore_heelFIX(1,35:51)
% for fore foot fulcrum point:  x_a_fore_heelFIX(35:51) ; z_a_fore_heelFIX(35:51)
% for fore foot contact point: x_x_contact_fore_heelFIX(35:51) ; z_x_contact_fore_heelFIX(35:51)
%
% for fake ankle: x_hind_heelFIX(end,35:51) ; z_hind_heelFIX(end,35:51)
% for real ankle: x_ankleReal_heelFIX(35:51) ; z_ankleReal_heelFIX(35:51)

%% in stage 3:
% for hind foot toe point:  x_heel_stage3_heelFIX(52:68) ; z_heel_stage3_heelFIX(52:68)
% for hind foot fulcrum point:  x_a_hind_stage3_heelFIX(52:68) ; z_a_hind_stage3_heelFIX(52:68)
%
% for fore foot: x_fore_heelFIX(:,52:68) ; z_fore_heelFIX(:,52:68)
% for fore foot toe point: x_fore_heelFIX(1,52:68) ; z_fore_heelFIX(1,52:68)
% for fore foot fulcrum point:  x_a_fore_heelFIX(52:68) ; z_a_fore_heelFIX(52:68)
% for fore foot contact point: x_x_contact_fore_heelFIX(52:68) ; z_x_contact_fore_heelFIX(52:68)
%
% for fake ankle: x_fore_heelFIX(end,52:68) ; z_fore_heelFIX(end,52:68)
% for real ankle: x_ankleReal_heelFIX(52:68) ; z_ankleReal_heelFIX(52:68)

%% set up the figures and in the proper position, according to different screen
% for COP
fig2 = figure(5);
pos_fig2 = [962 0 960 1080];
set(fig2,'Position',pos_fig2)

% for roll-over animation
fig1 = figure(6);
pos_fig1 = [0 0 960 1080];
set(fig1,'Position',pos_fig1)

% set the ground
yline(0,'--','linewidth',2);hold on
axis equal;grid on

%%
for j=1:1:length(foot_angle_allstages)
    %% figure 1 ;set the title
    if ismember(j,index_stage1)
        title('stage1: heel-strike');
        ax = gca;
        ax.FontSize = 40;
    end
    if ismember(j,index_stage21)
        title('stage2.1: foot-flat');
        ax = gca;
        ax.FontSize = 40;
    end
    if ismember(j,index_stage22)
        title('stage2.2: foot-flat');
        ax = gca;
        ax.FontSize = 40;
    end
    if ismember(j,index_stage3)
        title('stage3: toe-off');
        ax = gca;
        ax.FontSize = 40;
    end

    %%
    % Stage1
    if ismember(j,index_stage1)
        a=plot(x_hind_heelFIX(:,j)*1000,z_hind_heelFIX(:,j)*1000,'-k','linewidth',15);hold on
        b=plot(x_hind_heelFIX(1,j)*1000,z_hind_heelFIX(1,j)*1000,'.k','markersize',80);hold on
        c=plot(x_a_hind_heelFIX(j)*1000,z_a_hind_heelFIX(j)*1000,'.g','markersize',60);hold on
        d=plot(x_x_contact_hind_heelFIX(j)*1000,z_x_contact_hind_heelFIX(j)*1000,'.r','markersize',50);hold on
        
        e=plot([x_hind_heelFIX(end,j),x_a_fore_stage1_heelFIX(j),x_toe_stage1_heelFIX(j)]*1000,[z_hind_heelFIX(end,j),z_a_fore_stage1_heelFIX(j),z_toe_stage1_heelFIX(j)]*1000,'-k','linewidth',15);hold on
        f=plot(x_toe_stage1_heelFIX(j)*1000,z_toe_stage1_heelFIX(j)*1000,'.k','markersize',80);hold on
        g=plot(x_a_fore_stage1_heelFIX(j)*1000,z_a_fore_stage1_heelFIX(j)*1000,'.g','markersize',60);hold on
        
        h=plot([x_hind_heelFIX(end,j),x_ankleReal_heelFIX(j)]*1000,[z_hind_heelFIX(end,j),z_ankleReal_heelFIX(j)]*1000,'.-k','markersize',80,'linewidth',15);hold on
    end
    
    % Stage2
    if ismember(j,[index_stage21,index_stage22])
        a=plot(x_hind_heelFIX(:,j)*1000,z_hind_heelFIX(:,j)*1000,'-k','linewidth',15);hold on
        b=plot(x_hind_heelFIX(1,j)*1000,z_hind_heelFIX(1,j)*1000,'.k','markersize',80);hold on
        c=plot(x_a_hind_heelFIX(j)*1000,z_a_hind_heelFIX(j)*1000,'.g','markersize',60);hold on
        d=plot(x_x_contact_hind_heelFIX(j)*1000,z_x_contact_hind_heelFIX(j)*1000,'.r','markersize',50);hold on
        
        e=plot(x_fore_heelFIX(:,j)*1000,z_fore_heelFIX(:,j)*1000,'-k','linewidth',15);hold on
        f=plot(x_fore_heelFIX(1,j)*1000,z_fore_heelFIX(1,j)*1000,'.k','markersize',80);hold on
        g=plot(x_a_fore_heelFIX(j)*1000,z_a_fore_heelFIX(j)*1000,'.g','markersize',60);hold on
        h=plot(x_x_contact_fore_heelFIX(j)*1000,z_x_contact_fore_heelFIX(j)*1000,'.r','markersize',50);hold on
        
        w=plot([x_hind_heelFIX(end,j),x_ankleReal_heelFIX(j)]*1000,[z_hind_heelFIX(end,j),z_ankleReal_heelFIX(j)]*1000,'.-k','markersize',80,'linewidth',15);hold on
        
    end
    
    % Stage3
    if ismember(j,index_stage3)
        a=plot(x_fore_heelFIX(:,j)*1000,z_fore_heelFIX(:,j)*1000,'-k','linewidth',15);hold on
        b=plot(x_fore_heelFIX(1,j)*1000,z_fore_heelFIX(1,j)*1000,'.k','markersize',80);hold on
        c=plot(x_a_fore_heelFIX(j)*1000,z_a_fore_heelFIX(j)*1000,'.g','markersize',60);hold on
        d=plot(x_x_contact_fore_heelFIX(j)*1000,z_x_contact_fore_heelFIX(j)*1000,'.r','markersize',50);hold on
        
        e=plot([x_fore_heelFIX(end,j),x_a_hind_stage3_heelFIX(j),x_heel_stage3_heelFIX(j)]*1000,[z_fore_heelFIX(end,j),z_a_hind_stage3_heelFIX(j),z_heel_stage3_heelFIX(j)]*1000,'-k','linewidth',15);hold on
        f=plot(x_heel_stage3_heelFIX(j)*1000,z_heel_stage3_heelFIX(j)*1000,'.k','markersize',80);hold on
        g=plot(x_a_hind_stage3_heelFIX(j)*1000,z_a_hind_stage3_heelFIX(j)*1000,'.g','markersize',60);hold on
        
        h=plot([x_fore_heelFIX(end,j),x_ankleReal_heelFIX(j)]*1000,[z_fore_heelFIX(end,j),z_ankleReal_heelFIX(j)]*1000,'.-k','markersize',80,'linewidth',15);hold on
    end
    
    % also plot the COP of full foot
    COPPREAL=plot(COP_heelFIX(j)*1000,0,'bo','markersize',20,'LineWidth',4);hold on
    
    % 
    xlim([-5,300]);xlabel('x (mm)');ylabel('z (mm)');ylim([-5,250])

    %% figure 2: set the title
    figure(5);
    if ismember(j,index_stage1)
        sgt=sgtitle('stage1: heel-strike');
        sgt.FontSize = 40;
    end
    if ismember(j,index_stage21)
        sgt=sgtitle('stage2.1: foot-flat');
        sgt.FontSize = 40;
    end
    if ismember(j,index_stage22) 
        sgt=sgtitle('stage2.2: foot-flat');
        sgt.FontSize = 40;
    end
    if ismember(j,index_stage3)
        sgt=sgtitle('stage3: toe-off');
        sgt.FontSize = 40;
    end
    
    %% plot figure2 for the three COPs
    % hind foot COP
    subplot(3,1,1);
    % plot the points
    plot(foot_angle_allstages(j),COP_hind_heelFIX(j)*1000,'.r','markersize',25);hold on
    % plot the line
    if j ~=1
        plot(foot_angle_allstages(j-1:j),COP_hind_heelFIX(j-1:j)*1000,'--k','linewidth',2);hold on
    end
    xlim([-21 41]);title('COP of Hind Foot (mm)');grid on;ylim([0 14.5])
    
    % fore foot COP
    subplot(3,1,2);
    % plot the points
    plot(foot_angle_allstages(j),COP_fore_heelFIX(j)*1000,'.r','markersize',25);hold on
    % plot the line
    if j ~=1
        plot(foot_angle_allstages(j-1:j),COP_fore_heelFIX(j-1:j)*1000,'--k','linewidth',2);hold on
    end
    xlim([-21 41]);title('COP of Fore Foot (mm)');grid on;ylim([200 260])
    
    % full foot COP
    subplot(3,1,3);
    % plot the points
    plot(foot_angle_allstages(j),COP_heelFIX(j)*1000,'.r','markersize',25);hold on
    % plot the line
    if j ~=1
        plot(foot_angle_allstages(j-1:j),COP_heelFIX(j-1:j)*1000,'--k','linewidth',2);hold on
    end
    xlim([-21 41]);title('COP of Full Foot (mm)');grid on;xlabel('Foot Angle (degree)');ylim([0 290])

    %% pause
    pause(0.0001)
    % if want to pause at the end:
    if j==length(foot_angle_allstages)
        %pause
    end

    %% delete figure 1
    figure(6)
    delete([a,b,c,d,e,f,g,h])
    if ismember(j,[index_stage21,index_stage22])
        delete(w)
    end
    delete(COPPREAL)
end