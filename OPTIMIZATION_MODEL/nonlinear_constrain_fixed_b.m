function [nonlinear_ineq,nonlinear_eq] = nonlinear_constrain_fixed_b(input)
% the nonlinear constrain when the width is set as constant
% Here: make sure the optimized thickness profile is under the safty constrain (stress<n*strength) 
% through safty constrain computation
%% Three percentage-inputs here: (Please see explanation in the root)
n_h = input(1); 
n_c = input(2); 
n_f = input(3);

%% Corresponding three design here: (Please see explanation in the root)
global L h_max;
h_min = h_max*n_h;
c = L*n_c;
a_max = L-c*n_f; 

%% Some constants of Gordon Composites™ Thermoset barstock GC-67-UBW
TS = 150000/0.000145037738; % flexture strength
E = 33.10*10^9;

%% Safety constrain: 
% deflect the keel when fulcrum at a_max (a large load at the end), 
% and make sure each point's stress is under the some percent of the flexural strength
global P_max n;

%% Get the thickness profile and the width profile
% set the x array
xx_NC=linspace(0,L-c,100);
xx_C_underA_MAX =linspace(L-c,a_max,100);
xx_C_overA_MAX=linspace(a_max,L,100);
xx = [xx_NC, xx_C_underA_MAX, xx_C_overA_MAX];

% get h(x)
h(1:100) = h_min+(h_max-h_min)*(xx(1:100))/(L-c);
h(101:200) = h_max;
h(201:300) = h_max;

% get b(x)
b=70/1000;

% get sigma_max:
sigma(1:200)=(6*P_max*(xx(1:200)))./(b*((h(1:200)).^2));
sigma(201:300)=(6*P_max*(L-xx(201:300))*(a_max/(L-a_max)))./(b*((h(201:300)).^2));

%% the nonlinear equality: make sure the thickness is not too small to break the keel
nonlinear_ineq = max(sigma)-n*TS;

%% we don't have nonlinear equality
nonlinear_eq = [];
end