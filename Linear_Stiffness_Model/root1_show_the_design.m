%% This script shows the design of the two keels
%%
HindFoot_design;
L_hind=L;
%% print the design:
fprintf('Design for HindFoot: \n')
fprintf('Keel length: %.2f mm \n',L*1000)
fprintf('Thickness_max: %.2f mm \n',h_max*1000)
fprintf('Thickness_min: %.2f mm \n',h_min*1000)
fprintf('UntaperPART length: %.2f mm \n',c*1000)
fprintf('Fulcrum max length: %.2f mm \n\n',a_max*1000)

%% plot the thickness and the width profile
% set the x array
xx_NC=linspace(0,L-c,100);
xx_C_underA_MAX =linspace(L-c,a_max,100);
xx_C_overA_MAX=linspace(a_max,L,100);
xx = [xx_NC, xx_C_underA_MAX, xx_C_overA_MAX];

% get h(x)
h(1:100) = h_min+(h_max-h_min)*(xx(1:100))/(L-c);
h(101:200) = h_max;
h(201:300) = h_max;
figure(1)
plot(xx*1000,h*1000,'-r','linewidth',2);hold on
ylabel('thickness h (mm)')
xlabel('x (mm)')
grid on;

% get b(x)
b(1:200)=(6*P_max*(xx(1:200)))./(n*TS*((h(1:200)).^2));
b(201:300)=(6*P_max*(L-xx(201:300))*(a_max/(L-a_max)))./(n*TS*((h(201:300)).^2));
if bb_constant==1
    b(1:300)=bb_constant_value*1000;
end
figure(2)
plot(xx*1000,b*1000,'-r','linewidth',2);hold on
ylabel('width b (mm)')
xlabel('x (mm)')
grid on;

%%
ForeFoot_design;
L_fore=L;
%% print staffs:
fprintf('Design for Forefoot: \n')
fprintf('Keel length: %.2f mm \n',L*1000)
fprintf('Thickness_max: %.2f mm \n',h_max*1000)
fprintf('Thickness_min: %.2f mm \n',h_min*1000)
fprintf('UntaperPART length: %.2f mm \n',c*1000)
fprintf('Fulcrum max length: %.2f mm \n\n',a_max*1000)

%% plot the thickness and the width profile
% set the x array
xx_NC=linspace(0,L-c,100);
xx_C_underA_MAX =linspace(L-c,a_max,100);
xx_C_overA_MAX=linspace(a_max,L,100);
xx = [xx_NC, xx_C_underA_MAX, xx_C_overA_MAX];

% get h(x)
h(1:100) = h_min+(h_max-h_min)*(xx(1:100))/(L-c);
h(101:200) = h_max;
h(201:300) = h_max;
figure(1)
plot(xx*1000,h*1000,'-g','linewidth',2)
legend('Hindfoot','Forefoot')
ylabel('thickness h (mm)')
xlabel('x (mm)')
grid on; 

% get b(x)
b(1:200)=(6*P_max*(xx(1:200)))./(n*TS*((h(1:200)).^2));
b(201:300)=(6*P_max*(L-xx(201:300))*(a_max/(L-a_max)))./(n*TS*((h(201:300)).^2));
if bb_constant==1
    b(1:300)=bb_constant_value*1000;
end
figure(2)
plot(xx*1000,b*1000,'-g','linewidth',2);
legend('Hindfoot','Forefoot')
ylabel('width b (mm)')
xlabel('x (mm)')
grid on; 