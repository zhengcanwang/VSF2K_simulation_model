%% Gordon Composites™ Thermoset barstock GC-67-UBW
TS = 150000/0.000145037738; % flexture strength MPa
E = 33.10*10^9; % FLEXURAL MODULUS MPa

%% Two parameters used for the non-break design of the width 
P_max = 800; % max force at the toe or heel
n = 0.9; % safty factor used to multiple with TS

%% design: (change here)
L=90/1000; % keel length 165 or 90

h_max = 4.19/1000;  % keel max thickness

n_h = 0.3245; % keel min thickness
h_min = 1/1000;%h_max*n_h;

n_c = 0.161; % h-constant part length
c = 0.9/1000;%L*n_c;

n_f = 0.257; % fulcrum farest position
a_max = 89.99/1000;%L-c*n_f;

%% if we choose to design with constant width
% 1 for constant width; 0 for unconstant (optimized or normal)
bb_constant=0;
bb_constant_value=70/1000;