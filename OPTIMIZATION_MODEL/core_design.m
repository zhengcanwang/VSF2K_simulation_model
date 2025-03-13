function [k_output]=core_design(h_min_input,c_input,a_max_input,P_input,a_input)
% inputs in: m, m, m, N, m
%% Set up the symbols
syms x1 x2 C1 C2 C3 C4 C5 C6 C7 C8 C9 C10
syms hh bb
global L h_max;

%% Some constants of Gordon Composites™ Thermoset barstock GC-67-UBW
TS = 150000/0.000145037738; % flexture strength
E = 33.10*10^9;

%% Import whether we try to use constant width here
global bb_constant bb_constant_value;

%% Safety constrain: 
% deflect the keel at a_max (a large load at the end), and make sure each point's stress is under the some percent of the flexural strength
global P_max n;

%% Write up the V for each section. See the Core writeups
% V1(x2,C1,C2)：Right of fulcrum + (L-c)_To_a + untaper
hh=h_max;
bb=6*P_max*x2/(n*TS*hh^2);
if bb_constant==1
    bb=bb_constant_value;
end
v1_dd = -(12*P_input/E)*(x2/(bb*hh^3));%v1_dd = -2*n*TS/(E*h_max)*(P/P_max);

% V2(x2,C3,C4)：Right of fulcrum + 0_To_(L-c) + taper
hh=h_min_input+(h_max-h_min_input)*x2/(L-c_input);
bb=6*P_max*x2/(n*TS*(hh)^2);
if bb_constant==1
    bb=bb_constant_value;
end
v2_dd = -(12*P_input/E)*(x2/(bb*hh^3));%v2_dd = (-2*n*TS/E)*(1/(h_min+(h_max-h_min)*x2/(L-c)))*(P/P_max);

% V5(x1,C9,C10)：Left of fulcrum + 0_To_L-a_max + untaper
hh=h_max;
bb=6*(a_max_input/(L-a_max_input))*P_max*x1/(n*TS*hh^2);
if bb_constant==1
    bb=bb_constant_value;
end
v5_dd = -(12*(a_input/(L-a_input))*P_input/E)*(x1/(bb*hh^3));%v5_dd = -2*n*TS*(a/(L-a))/(E*h_max*(a_max_input/(L-a_max_input)))*(P/P_max);

% V3(x1,C5,C6)：Left of fulcrum + L-a_max_input_To_c + untaper
hh=h_max;
bb=6*P_max*(L-x1)/(n*TS*hh^2);
if bb_constant==1
    bb=bb_constant_value;
end
v3_dd = -(12*(a_input/(L-a_input))*P_input/E)*(x1/(bb*hh^3));%v3_dd = (-2*n*(a/(L-a))*TS/(E*h_max))*(x1/(L-x1))*(P/P_max);

% V4(x1,C7,C8)：Left of fulcrum + c_To_L-a + taper
hh=h_min_input+(h_max-h_min_input)*(L-x1)/(L-c_input);
bb=6*P_max*(L-x1)/(n*TS*(hh)^2);
if bb_constant==1
    bb=bb_constant_value;
end
v4_dd = -(12*(a_input/(L-a_input))*P_input/E)*(x1/(bb*hh^3));%v4_dd = (-2*n*(a/(L-a))*TS/E)*(x1/((L-x1)*(h_min+(h_max-h_min)*(L-x1)/(L-c))))*(P/P_max);

%% integration 
v1_d = int(v1_dd,x2)+C1;
v1 = int(v1_d,x2)+C2;
v2_d = int(v2_dd,x2)+C3;
v2 = int(v2_d,x2)+C4;
v3_d = int(v3_dd,x1)+C5;
v3 = int(v3_d,x1)+C6;
v4_d = int(v4_dd,x1)+C7;
v4 = int(v4_d,x1)+C8;
v5_d = int(v5_dd,x1)+C9;
v5 = int(v5_d,x1)+C10;

%% Start solving for x_contact: total 2 conditions:
%% 1. when fulcrum at untaper part: use all except v4
if (a_input>=(L-c_input)) && (a_input<a_max_input) 
    % create the 8 boundry conditions equations
    eqns = [subs(v5,x1,0) == 0,...
            subs(v3,x1,L-a_input) == 0,...
            subs(v1,x2,a_input) == 0,...
            subs(v3_d,x1,L-a_input) == -(subs(v1_d,x2,a_input)),...
            subs(v1,x2,L-c_input)==subs(v2,x2,L-c_input),...
            subs(v1_d,x2,L-c_input)==subs(v2_d,x2,L-c_input),...
            subs(v3,x1,L-a_max_input)==subs(v5,x1,L-a_max_input),...
            subs(v3_d,x1,L-a_max_input)==subs(v5_d,x1,L-a_max_input)];
        
        % get v2 constants C3 C4
        S = solve(eqns,[C1 C2 C3 C4 C5 C6 C9 C10]);
    
%% 2. when fulcrum at taper part: use all except v1
else 
    % create the 8 boundry conditions equations
    eqns = [subs(v5,x1,0) == 0,...
            subs(v4,x1,L-a_input) == 0,...
            subs(v2,x2,a_input) == 0,...
            subs(v4_d,x1,L-a_input) == -(subs(v2_d,x2,a_input))...
            subs(v3,x1,c_input)==subs(v4,x1,c_input),...
            subs(v3_d,x1,c_input)==subs(v4_d,x1,c_input),...
            subs(v3,x1,L-a_max_input)==subs(v5,x1,L-a_max_input),...
            subs(v3_d,x1,L-a_max_input)==subs(v5_d,x1,L-a_max_input)];
        
    % get v2 constants C3 C4
    S = solve(eqns,[C3 C4 C5 C6 C7 C8 C9 C10]);
end

%% Get v2 full analyticaly equation
get_v2_equation = subs(v2,C3,double(S.C3));
get_v2_equation = subs(get_v2_equation,C4,double(S.C4));

%% Get the deflection at the top (toe/heel)
get_v2_value_at_tip = subs(get_v2_equation,x2,0);

%% Get the stiffness in N/mm
k_output = -P_input/double(get_v2_value_at_tip)/1000;

% note: the deflection should be a non-positive number as it bends down (see the force analysis supplementary)
% We kind of starts this study with contact force pointing down,so...deflection is non-positive. haha but every other staffs is just fine.
% we will add a "-" to convert to positive here
end