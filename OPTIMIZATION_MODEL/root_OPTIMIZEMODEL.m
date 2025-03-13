clear all; close all; clc;
%% The five design input for one keel
% 1. The keel length L: this is mannualy set
% 2. The max thickness h_max: this is set by the given material 4.191 mm
% 3. The min thickness h_min: this is being optimized here. (for simplicity, optimized n_h, percentage of h_max)
% 4. The untaper part length c: this is being optimized here. (for simplicity, optimized n_c, percentage of L)
% 5. The the max fulcrum position a_max (must on c): this is being optimized here. (for simplicity, optimized n_f, a_max=L-n_f*c)

%% So, in this optimization program: three parameter-inputs
% 1. The min thickness h_min. For simplicity, optimized n_h, percentage of h_max)
% 2. The untaper part length c. For simplicity, optimized n_c, percentage of L)
% 3. The the max fulcrum position a_max. For simplicity, optimized n_f, percentage of L)

%% So, the 1. length L and the 2. max thickness h_max is mannualy set here:
global L h_max;
L = 90/1000; 
h_max = 4.191/1000; 

%% The computation of the width:
% The width is directly computed through the "safety constrain" from the above five parameters; 
% or, mannualy set it as a constant width,
% then the "safety constrain" will be a nonlinear-constrain on the thickness in the optimization problem
% (make sure the thickness is not too thin to break)

% if we choose to design with constant width
% 1 for constant width; 0 for unconstant (optimized or normal)
global bb_constant bb_constant_value;
bb_constant=0; % mannualy set here
bb_constant_value=70/1000; % mannualy set here

%% Safety constrain: (change here, if needed)
% deflect the keel when fulcrum at a_max (a large load at the end P_max), 
% and make sure each point's stress is under the some percent (n) of the flexural strength
global P_max n;
P_max = 800; 
n = 0.9; 

%% Linear constrains of the three inputs
initial_guess = [0.5; 0.5; 0.5]; % some random initial guess for the optimum 

Aeq = []; Beq = [];  % no linear equality constraints
Aineq = []; Bineq = [];  % no linear inequality constraints
LB = [ 0.01; 0.01; 0.01];  % lower bound on the variables (all percentage)
UB = [ 0.99; 0.99; 0.99];  % upper bound on the variables (all percentage)

%% Solve the optimization problem:
% the core of design:
% when the fuclrum @ random position (I set it at the middle of a_max),
% apply a random load at the end (toe/heel) (I set it at 400N),
% compute the deflection at the end (toe/heel), 
% and make "load/deflection" as small as possible! (soft)

% display the iteration process
options = optimset('display','iter','MaxFunEvals',20000,'MaxIter',20000);

% get optimal n_h; n_c; n_f:
if bb_constant==1
    [input_result,opt_function] = fmincon(@objectiveFunction,initial_guess,Aineq,Bineq,Aeq,Beq,LB,UB,@nonlinear_constrain_fixed_b,options)
end
if bb_constant==0
    [input_result,opt_function] = fmincon(@objectiveFunction,initial_guess,Aineq,Bineq,Aeq,Beq,LB,UB,@nonlinear_constrain,options)
end