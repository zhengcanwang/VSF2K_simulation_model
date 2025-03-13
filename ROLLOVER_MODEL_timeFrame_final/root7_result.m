%% Result1: Plot the Roll Over Shape
for i = 1:1:length(foot_angle_allstages)
    % transform matrix: heel-fix coordinate to the moving ankle coordinate (See geometry analysis)
    T_heelfixed2anklemoved=[cos(foot_angle_allstages(i)*pi/180) 0 sin(foot_angle_allstages(i)*pi/180) ankle_x_heelFIX(i);...
                    0 1 0 0;...
                    -sin(foot_angle_allstages(i)*pi/180) 0 cos(foot_angle_allstages(i)*pi/180) ankle_z_heelFIX(i);...
                    0 0 0 1];
                
    % change the COP to ankle coordinate:
    tempp = inv(T_heelfixed2anklemoved)*[COP_heelFIX(i);0;0;1];
    COP_ankleC_x(i)= tempp(1)*1000;    
    COP_ankleC_z(i)= tempp(3)*1000;
end

figure(3)
plot(COP_ankleC_x(index_stage1),COP_ankleC_z(index_stage1),'-r.','MarkerSize',15);hold on % Stage1
plot(COP_ankleC_x([index_stage21,index_stage22]),COP_ankleC_z([index_stage21,index_stage22]),'-g.','MarkerSize',15) ;hold on % Stage2
plot(COP_ankleC_x(index_stage3),COP_ankleC_z(index_stage3),'-b.','MarkerSize',15);hold on % Stage3
legend({'Stage1','Stage2','Stage3'}, 'location', 'NorthWest', 'Fontsize', 30)
grid on;axis equal
xlabel('x (mm)')
ylabel('z (mm)')

%% Result1: Get the ROS's center and radius and EFLR
[center_x,center_z,radius,EFL]=ROS_centerRadii_finding(COP_ankleC_x,COP_ankleC_z,foot_angle_allstages);
EFLR=EFL/foot_length;

%% Result2: Get the DMAMA (Plantar moment is positive)
DMAMA=sum((COP_heelFIX-ankle_x_heelFIX).*load_total_allstages)/sum(load_total_allstages)*1000;
DMAMA_N=DMAMA/foot_length;

%% Result3: Ankle moment @ zero footangle
% used to calculate the angular stiffness
% Ankle moment (Nmm) at each foot angle: (plantar ankle moment is positive)
for i = 1:1:length(foot_angle_allstages)
    ankle_moment(i)=(COP_heelFIX(i)-ankle_x_heelFIX(i))*load_total_allstages(i)*1000;
end

% index of zero footangle
[~,index_zero]=min(abs(foot_angle_allstages-0));
ankle_moment_zero=ankle_moment(index_zero);

%% Result4: the distance between contact points of hindfoot and forefoot @ zero footangle
% i.e.: the "l" used in the angular model
% NOTE: for this part, only when at the neutral ankle alignment matters!
l_angular=COP_fore_heelFIX(index_zero)-COP_hind_heelFIX(index_zero);

%% Result5: Finally, run the animation:
root8_result_animation;