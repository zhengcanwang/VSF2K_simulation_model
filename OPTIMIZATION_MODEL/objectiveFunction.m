function objval = objectiveFunction(input)
%% Three percentage-inputs here: (Please see explanation in the root)
n_h = input(1); 
n_c = input(2); 
n_f = input(3);

%% Corresponding three design here: (Please see explanation in the root)
global L h_max;
h_min = h_max*n_h;
c = L*n_c;
a_max = L-c*n_f; 

%% Load used for optimization
P = 400;

%% Flucrum position used for optimization
a=a_max*0.5;

%% Start the core to calculate deflection and stiffness
k=core_design(h_min,c,a_max,P,a);

%% The objective value is just the stiffness (as soft as possible!)
objval = k;
end

