%% Use the Resampling and Averaging Algorithm to get the real center point and the radius of ROS
% 1. starts with zeros center as the center; 
% 2. split all the points into angle-equally-distributed slots from the center; 
% 3. take the mean of the points in each slot;
% 4. Fit “the mean of the points of each slot” and get the new center and new radius;
% 5. make the new center as the center
% 6. if not in the resolution: repeat step 2-5; if in resolution: stop.

% inputs are in mm, mm, and degrees
function [center_x,center_z,radius,EFL]=ROS_centerRadii_finding(COP_ankleC_x_input,COP_ankleC_z_input,foot_angle_allstages_input)
%% symbols to find intercepts
syms xx;

%% Find the angle of opposite heel-strike - @ 500ms - from "Used_for_twoFormulaFromISO.m"
% OHC: opposite-heel-contact
angle_OHC=26.7120;

% get the index of end_point of the circle fit
[~,index_OHC]=min(abs(foot_angle_allstages_input-angle_OHC));

% get the index of start_point of the circle fit
[~,peak_index] = findpeaks(COP_ankleC_z_input);
index_HC=peak_index(1); % just use the first peak here (the peak in stage 1 - heel strike) (normally there are two peaks)

%% first get the effective foot length
EFL=COP_ankleC_x_input(index_OHC)-COP_ankleC_x_input(1);

%% set up how many slots we use for the algorithm
n_slots=100;

%% start the iteration with zeros center
center_x=0;
center_z=0;
delta_center_x=10;
delta_center_z=10;
number_loop=0;

%% start the while loop
while ((delta_center_z>1) || (delta_center_x>1)) && (number_loop<30) % avoid infinite iteration ans set the resolution
    %% initialize the array to be refitted
    contact_point_ankleC_x_mean=[];
    contact_point_ankleC_z_mean=[];
    
    %% get the slopes of the right edge line and left edge line
    % get the two y=kx+b lines from the center to two edge points
    k_b_HC = polyfit([center_x, COP_ankleC_x_input(index_HC)], [center_z, COP_ankleC_z_input(index_HC)], 1);
    k_b_OHC = polyfit([center_x, COP_ankleC_x_input(index_OHC)], [center_z, COP_ankleC_z_input(index_OHC)], 1);

    % three cases: 
    % when left-edge-line has positive slope (angle) and when right-edge-line has negative slope (angle)
    if (k_b_HC(1)>0) && (k_b_OHC(1)<0)
        left_edge=atan(k_b_HC(1));
        right_edge=pi+atan(k_b_OHC(1)); % note here! tan(angle)=tan(pi+angle); angle is negative here
        % the reason why "add a pi" here is because: in this case, the angle of the slope
        % is from a positive number up to 90 degree (infinite slope) then goes from -90 degree down to that negative number
        % So, by adding pi, it goes from a acute angle (positive slope) to obtuse angle (negative slope).
        % More easier to linspace!!!
    end
    % when left-edge-line has negative slope (angle) and when right-edge-line has negative slope (angle)
    if (k_b_HC(1)<0) && (k_b_OHC(1)<0)
        left_edge=atan(k_b_HC(1));
        right_edge=atan(k_b_OHC(1));
    end
    % when left-edge-line has positive slope (angle) and when right-edge-line has positive slope (angle)
    if (k_b_HC(1)>0) && (k_b_OHC(1)>0)
        left_edge=atan(k_b_HC(1));
        right_edge=atan(k_b_OHC(1));
    end
    
    %% get the array of the slopes of "the lines (angle-equally-distributed) bonded the edges"
    array_slope_angles=linspace(left_edge,right_edge,n_slots+1);
    array_slope=tan(array_slope_angles);

    %% find the mean or the average of the intercepts (empty slots) for each slot
    % detect whether this is points in a slots:
    for loop1=1:1:n_slots
        % get the sum of the points in one slot
        contact_point_ankleC_x_sum(loop1)=0;
        contact_point_ankleC_z_sum(loop1)=0;
        count=0;
        
        % check whether there is points inside each slot, sum them, and count them
        % for all calculated COP from the lines: z = m*(x - x1) + z1;or x = x1+(z - z1)/m
        % (x1,z1) is the center
        for loop2=index_HC:1:index_OHC
            % left side case
            % when the slot is bounded by "left line with +slope" and "right line with +slope"
            if (((COP_ankleC_x_input(loop2)-center_x)*array_slope(loop1)+center_z)>= COP_ankleC_z_input(loop2)) ...
                && (((COP_ankleC_x_input(loop2)-center_x)*array_slope(loop1+1)+center_z)<= COP_ankleC_z_input(loop2))...
                && (array_slope(loop1)>0) && (array_slope(loop1+1)>0)
                count=count+1;
                contact_point_ankleC_x_sum(loop1)=contact_point_ankleC_x_sum(loop1)+COP_ankleC_x_input(loop2);
                contact_point_ankleC_z_sum(loop1)=contact_point_ankleC_z_sum(loop1)+COP_ankleC_z_input(loop2);
            end
            
            % middle case (only one slot in this case)
            % when the slot is bounded by "left line with +slope" and "right line with -slope"
            if (((COP_ankleC_z_input(loop2)-center_z)/array_slope(loop1)+center_x)<= COP_ankleC_x_input(loop2)) ...
                && (((COP_ankleC_z_input(loop2)-center_z)/array_slope(loop1+1)+center_x)>= COP_ankleC_x_input(loop2))...
                && (array_slope(loop1)>0) && (array_slope(loop1+1)<0)
                count=count+1;
                contact_point_ankleC_x_sum(loop1)=contact_point_ankleC_x_sum(loop1)+COP_ankleC_x_input(loop2);
                contact_point_ankleC_z_sum(loop1)=contact_point_ankleC_z_sum(loop1)+COP_ankleC_z_input(loop2);
            end
            
            % right side case
            % when the slot is bounded by "left line with -slope" and "right line with -slope"
            if (((COP_ankleC_x_input(loop2)-center_x)*array_slope(loop1)+center_z)<= COP_ankleC_z_input(loop2)) ...
                && (((COP_ankleC_x_input(loop2)-center_x)*array_slope(loop1+1)+center_z)>= COP_ankleC_z_input(loop2))...
                && (array_slope(loop1)<0) && (array_slope(loop1+1)<0)
                count=count+1;
                contact_point_ankleC_x_sum(loop1)=contact_point_ankleC_x_sum(loop1)+COP_ankleC_x_input(loop2);
                contact_point_ankleC_z_sum(loop1)=contact_point_ankleC_z_sum(loop1)+COP_ankleC_z_input(loop2);
            end
        end
        
        %% if this slot has some COPs:
        if count ~= 0
            % get the mean value to update the array to be refitted
            contact_point_ankleC_x_mean(loop1)=contact_point_ankleC_x_sum(loop1)/count;
            contact_point_ankleC_z_mean(loop1)=contact_point_ankleC_z_sum(loop1)/count;
        end

        %% if this slot has no COP:
        if count == 0
            % connect each COP with the current center and get the slope.
            for loop2=index_HC:1:index_OHC
                    slope_array_COPwithCenter(loop2)=(center_z-COP_ankleC_z_input(loop2))/(center_x-COP_ankleC_x_input(loop2));
            end
            
            % get the the two points that disclosing this empty slot:
            % left side case
            if (array_slope(loop1)>0) && (array_slope(loop1+1)>0)
                % get the left bond index: this bond must be a positive slope
                for loop2=index_HC:1:index_OHC 
                    if slope_array_COPwithCenter(loop2)>array_slope(loop1) || (slope_array_COPwithCenter(loop2)<0)
                        index_leftpoint=loop2-1;
                        break;
                    end
                end
                 % get the right bond index: (this bond might be a larger positive slope, or just start to being negative slope)
                for loop2=index_HC:1:index_OHC
                    if (slope_array_COPwithCenter(loop2)>array_slope(loop1+1)) || (slope_array_COPwithCenter(loop2)<0)
                        index_rightpoint=loop2;
                        break;
                    end
                end 
            end

            % middle case
            if (array_slope(loop1)>0) && (array_slope(loop1+1)<0)
                % get the left bond index: this bond must be a positive slope
                % get the right bond index: this bond must be a negative slope
                for loop2=index_HC:1:index_OHC 
                    if slope_array_COPwithCenter(loop2)<0
                        index_leftpoint=loop2-1;
                        index_rightpoint=loop2;
                        break;
                    end
                end
            end

            % right side case 
            % note: not considering the case that there are empty slots in stage3, because it is probably impossible. 
            % If there are, we need to face a situation that slope_array_COPwithCenter will be not monotonic 
            % since: (OHC might happen after the peak in stage 3!)
            if (array_slope(loop1)<0) && (array_slope(loop1+1)<0)
                % get the left bond index: this bond can be a positive slope or negative
                for loop2=index_HC:1:index_OHC 
                    if ((slope_array_COPwithCenter(loop2)<0) && (slope_array_COPwithCenter(loop2+1)>array_slope(loop1))) ...
                        || ((slope_array_COPwithCenter(loop2)>0) && (slope_array_COPwithCenter(loop2+1)<0) && (slope_array_COPwithCenter(loop2+1)>array_slope(loop1)))
                        index_leftpoint=loop2;
                        break;
                    end
                end
                 % get the right bond index: this bond must be a negative slope
                for loop2=index_HC:1:index_OHC
                    if (slope_array_COPwithCenter(loop2)<0) && (slope_array_COPwithCenter(loop2)>array_slope(loop1+1))
                        index_rightpoint=loop2;
                        break;
                    end
                end 
            end

            % the line of leftpoint and rightpoint:
            % y = ((y2 - y1) / (x2 - x1)) * x + (y1 - ((y2 - y1) / (x2 - x1)) * x1)
            mm=(COP_ankleC_z_input(index_rightpoint)-COP_ankleC_z_input(index_leftpoint))/(COP_ankleC_x_input(index_rightpoint)-COP_ankleC_x_input(index_leftpoint));
            bb=(COP_ankleC_z_input(index_leftpoint) - mm * COP_ankleC_x_input(index_leftpoint));
            
            % get the two intercepts between the line of leftpoint and rightpoint with the two slot-lines:
            sol_xx=solve(((xx-center_x)*array_slope(loop1)+center_z == mm*xx+bb),xx);
            intercept_left_x=double(sol_xx);
            intercept_left_z=mm*intercept_left_x+bb;

            % get the two intercepts between the line of leftpoint and rightpoint with the two slot-lines:
            sol_xx=solve(((xx-center_x)*array_slope(loop1+1)+center_z == mm*xx+bb),xx);
            intercept_right_x=double(sol_xx);
            intercept_right_z=mm*intercept_right_x+bb;
            
            % get the average intercepts to update the array to be refitted
            contact_point_ankleC_x_mean(loop1)=(intercept_right_x+intercept_left_x)/2;
            contact_point_ankleC_z_mean(loop1)=(intercept_right_z+intercept_left_z)/2;
        end
    end

    %% Clear the black slot dots
    if number_loop~=0
        delete(blackDOT);
        delete(rockerCircle);
        delete(rockerCircleCenter);
    end
    
    %% refit the circle, and plot the points we used in the same plot with ROS
    % with resample: GOOD!!!
    [center_x_new,center_z_new,radius,~] = circfit(contact_point_ankleC_x_mean,contact_point_ankleC_z_mean);
    % without resample: direct Least-square BAD!!!
    %[center_x_new,center_z_new,radius,~] = circfit(COP_ankleC_x_input(index_HC:index_OHC),COP_ankleC_z_input(index_HC:index_OHC));
    
    % plot with the ROS plot
    blackDOT=plot(contact_point_ankleC_x_mean,contact_point_ankleC_z_mean,'k.','MarkerSize',25);hold on
    % you can also draw the circle here
    rockerCircle=viscircles([center_x_new,center_z_new],radius,'LineStyle','--','Color','k','linewidth',2);hold on
    rockerCircleCenter=plot(center_x_new,center_z_new,'.m','MarkerSize',20);
    grid on;axis equal;
    pause(0.002)
    
    %% update the resolution and iteration number
    delta_center_x=abs(center_x_new-center_x);
    delta_center_z=abs(center_z_new-center_z);
    number_loop=number_loop+1;

    %% update the center
    center_x=center_x_new;
    center_z=center_z_new;
end
end