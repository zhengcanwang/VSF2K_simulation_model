clc;clear;close all 
%% The length L and the max thickness h_max is mannualy set here: 
global L h_max;
L = 90/1000; 
h_max = 4.191/1000; 

%% The computation of the width: (change here, if needed) (Please see explanation in the root)
global bb_constant bb_constant_value;
bb_constant=0; % mannualy set here
bb_constant_value=70/1000; % mannualy set here

%% Safety constrain: (change here, if needed) (Please see explanation in the root)
global P_max n;
P_max = 800; 
n = 0.9; 

%% The optimization results: (enter here!) (Please see explanation in the root)
n_h = 0.3234; % keel min thickness
n_c = 0.0100; % h-constant part length
n_f = 0.0100; % fulcrum farest position

% corresponding three design here:
h_min = 1/1000%h_max*n_h;
c = L*n_c;
a_max = L-c*n_f; 

%% Constants of Gordon Composites™ Thermoset barstock GC-67-UBW
TS = 150000/0.000145037738; % flexture strength
E = 33.10*10^9;

%% plot the thickness and the width profile：
% set the x array
xx_NC=linspace(0,L-c,50);
xx_C_underA_MAX =linspace(L-c,a_max,10);
xx_C_overA_MAX=linspace(a_max,L,10);
xx = [xx_NC, xx_C_underA_MAX, xx_C_overA_MAX];

% get h(x)
h(1:50) = h_min+(h_max-h_min)*(xx(1:50))/(L-c);
h(51:60) = h_max;
h(61:70) = h_max;
figure(1)
plot(xx*1000,h*1000,'-r','linewidth',2)
ylabel('h (mm)')
xlabel('x (mm)')
grid on;

% get b(x)
b(1:60)=(6*P_max*(xx(1:60)))./(n*TS*((h(1:60)).^2));
b(61:70)=(6*P_max*(L-xx(61:70))*(a_max/(L-a_max)))./(n*TS*((h(61:70)).^2));
if bb_constant==1
    b(1:70)=bb_constant_value*1000;
end
figure(2)
plot(xx*1000,b*1000,'-r','linewidth',2)
ylabel('b (mm)')
xlabel('x (mm)')
grid on

%% Start computing this“raw” designObjective-stiffness @ each fulcrum positions:
% P here (the applied force N)
P = 400;
%% for loop for Flucrum position
for ii = 0.25:0.05:0.95
% Flucrum position
a=a_max*ii; % in range of (0,a_max)

% Get the stiffness
k=core_design(h_min,c,a_max,P,a);

% plot
figure(3)
plot(a*1000,k,'*r','markersize',8)
ylabel('k (N/mm)')
xlabel('a (mm)')
grid on
hold on
end

%% Print the five design parameters:
fprintf('Keel length: %.2f mm \n',L*1000)
fprintf('Thickness_max: %.2f mm \n',h_max*1000)
fprintf('Thickness_min: %.2f mm \n',h_min*1000)
fprintf('UntaperPART length: %.2f mm \n',c*1000)
fprintf('Fulcrum max length: %.2f mm \n',L*1000-c*n_f*1000)