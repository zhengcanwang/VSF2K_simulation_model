function [k1,k2,k3,k4,k5,k6,a_array]=linearStiffnessModel(designOF_theta_n, hindORfore)
%% the ankle only move vertically (heel is not fix anymore)
%% In the linear Stiffness Simulation Model, alignment is always zero!
alignment=0;

%% testing load: linearly from 0 to 1230N
load_AOPA=linspace(0,1230,124);

%% set the testing angle, rolling angle, stiffness for each case
if hindORfore == "hind"
    figureNUM=20;
    theta_foot_AOPA=-15;
    theta_hind_offset=designOF_theta_n+alignment;
    rolling_angle=theta_hind_offset-theta_foot_AOPA;
    a_array=[0.015,0.03,0.045,0.06];
end
if hindORfore == "fore"
    figureNUM=21;
    theta_foot_AOPA=20;
    theta_fore_offset=designOF_theta_n-alignment; 
    rolling_angle=theta_fore_offset+theta_foot_AOPA;
    a_array=[0.03,0.06,0.09,0.12];
end

%% For each fulcrum setting:
for a=1:1:length(a_array)
    %% get the x_contact in heelUndeflected frame for each load
    for i=1:1:length(load_AOPA)
        [x_contact_hind_heelUNdeflected(i),~]=core(a_array(a), rolling_angle, load_AOPA(i)*cosd(rolling_angle), hindORfore);
    end

    %% get the v(0) for each load
    z_hind_heelUNdeflected=[];   
    for i=1:1:length(load_AOPA)
        x_contact=x_contact_hind_heelUNdeflected(i); % 3rd input 
        P=load_AOPA(i); % 2nd input 
     
        % get the deflection we want
        [deflection_total,~,~,~,~,~]...
            =core_animation(a_array(a), P*cosd(rolling_angle), x_contact, hindORfore, 2); % only two points is enough (we only want the v(0))
        
        % get the z of the deflected keel in the undeflected heel coordinate
        z_hind_heelUNdeflected=[z_hind_heelUNdeflected,-deflection_total];
    end
    
    %% get the shift of the ankle at each load
    for j = 1:1:length(load_AOPA)
        beta(j)=z_hind_heelUNdeflected(1,j)*cos((rolling_angle)*pi/180);
    end    
    
    %% plot load vs shift of ankle for each stiffness setting
    figure(figureNUM)
    subplot(2,2,a)
    plot(beta*1000, load_AOPA,'-k','DisplayName',strcat(['fulcrum position: ',num2str(a_array(a)*1000),'mm']));hold on
    grid on
    ylabel('Load (N)')
    xlabel('Ankle Displacement (mm)')

    %% the first stiffness: the AOPA stiffness
    k1(a)=load_AOPA(end)/beta(end)/1000;

    figure(figureNUM)
    subplot(2,2,a)
    plot([beta(1),beta(end)]*1000,[load_AOPA(1),load_AOPA(end)],'--r','DisplayName',strcat(['k1: ',num2str(k1(a)),'N/mm']));hold on

    %% the second stiffness: the initial fix contact point (heel/toe) linear stiffness
    % get the index where it is the end of the fix contact point
    index_FIXEND=find(x_contact_hind_heelUNdeflected,1,'first');
    p = polyfit(beta(1:(index_FIXEND-1))*1000,load_AOPA(1:(index_FIXEND-1)),1);
    k2(a)=p(1);

    figure(figureNUM)
    subplot(2,2,a)
    plot(beta(1:(index_FIXEND-1))*1000,polyval(p,beta(1:(index_FIXEND-1))*1000),'--g','DisplayName',strcat(['k2: ',num2str(k2(a)),'N/mm']));hold on
    
    %% the third stiffness: the non-fix contact point linear stiffness
    % get the index where it is the end of the fix contact point
    index_FIXEND=find(x_contact_hind_heelUNdeflected,1,'first');
    p = polyfit(beta(index_FIXEND:end)*1000,load_AOPA(index_FIXEND:end),1);
    k3(a)=p(1);

    figure(figureNUM)
    subplot(2,2,a)
    plot(beta(index_FIXEND:end)*1000,polyval(p,beta(index_FIXEND:end)*1000),'--b','DisplayName',strcat(['k3: ',num2str(k3(a)),'N/mm']));hold on
    legend('show')

    %% the forth stiffness: the mix linear stiffness
    p = polyfit(beta*1000,load_AOPA,1);
    k4(a)=p(1);

    figure(figureNUM)
    subplot(2,2,a)
    plot(beta*1000,polyval(p,beta*1000),'--m','DisplayName',strcat(['k4: ',num2str(k4(a)),'N/mm']));hold on
    legend('show')

    %% the fifth stiffness: the mix linear stiffness but with no offset
    ft = fittype('k*x', 'independent', {'x'}, 'dependent', 'y');
    opts = fitoptions('Method', 'NonlinearLeastSquares', ...
                  'StartPoint', 0,...  % Starting point for 'c'
                  'Lower', 0, ...      % Lower bound for 'c'
                  'Upper', 300);    % Upper bound for 'c'

    [sf,gof] = fit(beta'*1000,load_AOPA',ft,opts);
    k5(a)=sf.k;

    figure(figureNUM)
    subplot(2,2,a)
    plot(beta*1000,(sf.k)*beta*1000,'--c','DisplayName',strcat(['k5: ',num2str(k5(a)),'N/mm']));hold on
    legend('show')

    %% the sixth stiffness: the  stiffness 0 to some N
    % from the UsedtoSeeTheMaxLocalStiff.m and Used_toSeelocalStiffrange.m
    %hind_max= [740,770,800,820];
    %fore_max= [820,820,820,820];
    if hindORfore == "fore"
        range=1:1:83;
    end
    if hindORfore == "hind"
        if a_array(a) ==0.015
            range=1:1:75;
        end
        if a_array(a) ==0.03
            range=1:1:78;
        end
        if a_array(a) ==0.045
            range=1:1:81;
        end
        if a_array(a) ==0.06
            range=1:1:83;
        end
    end

    p = polyfit(beta(range)*1000,load_AOPA(range),1);
    k6(a)=p(1);

    figure(figureNUM)
    subplot(2,2,a)
    plot(beta(range)*1000,polyval(p,beta(range)*1000),'--','color',[0.600 0.400 0.200],'DisplayName',strcat(['k6: ',num2str(k6(a)),'N/mm']));hold off
    legend('show')

    %% save the load vs shift of ankle
    save_beta_load=[beta*1000;load_AOPA];
    if hindORfore == "hind"
        fname1 = sprintf('hindstiff_%.3f.mat', a_array(a));
    end
    if hindORfore == "fore"
        fname1 = sprintf('forestiff_%.3f.mat', a_array(a));
    end
    save(fname1,'save_beta_load')
end
end