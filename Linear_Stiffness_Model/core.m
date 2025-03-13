function [x_contact_output,deflectionATContact_output]=core(a_input, rolling_angle_input, P_input, hindORfore)
% note: the deflection should be a non-positive number as it bends down (see the force analysis supplementary)
% We kind of starts this study with contact force pointing down,so...deflection is non-positive. haha but every other staffs is just fine.
% we will add a "-" to convert to positive outside this function

% this core is used to find the x_contact point!
% input in degree, meter, and N
%% load the design
if hindORfore == "hind"
    HindFoot_design;
end
if hindORfore == "fore"
    ForeFoot_design;
end

%% load some symbols
syms x1 x2 C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 C12
syms hh bb x_contact
warning('off')

%% initialize the temporary parameters used in following
% two condition:
% 0: contact point at taper part
% 1: contact point at untaper part
FulcrumATuntaper_contactforceATtaper=0;

% 3+1 condition when solving for x_contact:
% 1: use except V4 (when fulcrum at untaper part) and (when contact point at taper part)
% 2: use except V4 and V2 (when fulcrum at untaper part) and (when contact point at untaper part)
% 3: use except V1 (when fulcrum at taper part) and (the contact point must at taper part)  
% 4: when the above three conditions not give result, then it means the load is not large enough, the contact point is at toe/heel point
Fulcrum_contactforce=4;

%% write up the V for each section. See the Core writeups
% V1(x2,C1,C2)：Right of fulcrum + (L-c)_To_a + untaper
hh = h_max;
bb = 6*P_max*x2/(n*TS*hh^2);
if bb_constant==1
    bb=bb_constant_value;
end
M = P_input*(x_contact-x2);
v1_dd = 12*M/E*(1/(bb*hh^3));

% V2(x2,C3,C4)：Right of fulcrum + Xcontact_To_(L-c) + taper
hh=h_min+(h_max-h_min)*x2/(L-c);
bb=6*P_max*x2/(n*TS*(hh)^2);
if bb_constant==1
    bb=bb_constant_value;
end
M = P_input*(x_contact-x2);
v2_dd = 12*M/E*(1/(bb*hh^3));

% V6(x2,C11,C12)：Right of fulcrum + 0_To_Xcontact + taper or untaper
v6_dd = 0;

% V5(x1,C9,C10)：Left of fulcrum + 0_To_(L-a_max) + untaper
hh=h_max;
bb=6*(a_max/(L-a_max))*P_max*x1/(n*TS*hh^2);
if bb_constant==1
    bb=bb_constant_value;
end
M = -((a_input-x_contact)/(L-a_input))*P_input*x1;
v5_dd = 12*M/E*(1/(bb*hh^3));

% V3(x1,C5,C6)：Left of fulcrum + (L-a_max)_To_c + untaper
hh=h_max;
bb=6*P_max*(L-x1)/(n*TS*hh^2);
if bb_constant==1
    bb=bb_constant_value;
end
M = -((a_input-x_contact)/(L-a_input))*P_input*x1;
v3_dd = 12*M/E*(1/(bb*hh^3));

% V4(x1,C7,C8)：Left of fulcrum + c_To_(L-a) + taper
hh=h_min+(h_max-h_min)*(L-x1)/(L-c);
bb=6*P_max*(L-x1)/(n*TS*(hh)^2);
if bb_constant==1
    bb=bb_constant_value;
end
M = -((a_input-x_contact)/(L-a_input))*P_input*x1;
v4_dd = 12*M/E*(1/(bb*hh^3));

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

v6_d = int(v6_dd,x2)+C11;
v6 = int(v6_d,x2)+C12;

%% Start solving for x_contact: total 3+1 conditions:
%% 1: use except V4 (when fulcrum at untaper part) and (when contact point at taper part)
if (a_input>=(L-c)) && (a_input<=a_max) && (c~=L) % if C=L then this part is impossible (no taper)
    %% get constants: create the ten boundry conditions equations. See the Core writeups
    eqns = [subs(v5,x1,0) == 0,...
            subs(v3,x1,L-a_input) == 0,...
            subs(v1,x2,a_input) == 0,...
            subs(v3_d,x1,L-a_input) == -(subs(v1_d,x2,a_input)),...
            subs(v1,x2,L-c)==subs(v2,x2,L-c),...
            subs(v1_d,x2,L-c)==subs(v2_d,x2,L-c),...
            subs(v3,x1,L-a_max)==subs(v5,x1,L-a_max),...
            subs(v3_d,x1,L-a_max)==subs(v5_d,x1,L-a_max),...
            subs(v6,x2,x_contact)==subs(v2,x2,x_contact),...
            subs(v6_d,x2,x_contact)==subs(v2_d,x2,x_contact)];
    S_C = solve(eqns,[C1 C2 C3 C4 C5 C6 C9 C10 C11 C12]);

     %% get V6 full analyticaly equation
     v6_d_equation = subs(v6_d,C11,S_C.C11);
     v6_equation = subs(v6,C11,S_C.C11);
     v6_equation = subs(v6_equation,C12,S_C.C12);

    %% get V2 full analyticaly equation and find the x_contact
    v2_d_equation = subs(v2_d,C3,S_C.C3);
    v2_equation = subs(v2,C3,S_C.C3);
    v2_equation = subs(v2_equation,C4,S_C.C4);
    
    % the core is here: finding the x_contact is finding "slope=tan(rollingangle)"
    v2_d_equation_Sub = subs(v2_d_equation,x2,x_contact);
    v2_d_equation_FINDX = [v2_d_equation_Sub == tan(rolling_angle_input*pi/180)];
    assume(x_contact >= 0 & x_contact <= L-c)
    x_contact_v2 = double(solve(v2_d_equation_FINDX,x_contact));
    
    % make sure only take the first solution, if the solution is nonempty 
    % (MATLAB somtimes gives a array with complex number)
    if (~isempty(x_contact_v2))  && (length(x_contact_v2)~=1)
        x_contact_v2=x_contact_v2(1);
    end
    
    % make sure the solution satisfies the range (x_contact at taper part)  
    if (~isempty(x_contact_v2))  &&  ((x_contact_v2<=L-c) && (x_contact_v2>=0))
        fprintf('* Fulcrum at untaper part and x_contact at taper part.\n');
        x_contact_output=x_contact_v2;
        Fulcrum_contactforce=1; %'Fulcrum AT untaper + contact force AT taper';
        FulcrumATuntaper_contactforceATtaper=1; % make sure not got to Condition 2
    end

    %% get V1 full analyticaly equation
    v1_d_equation = subs(v1_d,C1,S_C.C1);
    v1_equation = subs(v1,C1,S_C.C1);
    v1_equation = subs(v1_equation,C2,S_C.C2);

    %% get V3 full analyticaly equation
     v3_d_equation = subs(v3_d,C5,S_C.C5);
     v3_equation = subs(v3,C5,S_C.C5);
     v3_equation = subs(v3_equation,C6,S_C.C6);

    %% get V5 full analyticaly equation
     v5_d_equation = subs(v5_d,C9,S_C.C9);
     v5_equation = subs(v5,C9,S_C.C9);
     v5_equation = subs(v5_equation,C10,S_C.C10);
end

%% 2: use except V4 and V2 (when fulcrum at untaper part) and (when contact point at untaper part)
if ((a_input>=(L-c)) && (a_input<=a_max)) && (FulcrumATuntaper_contactforceATtaper==0)
    %% get constants: create the eight boundry conditions equations. See the Core writeups
    eqns = [subs(v5,x1,0) == 0,...
            subs(v3,x1,L-a_input) == 0,...
            subs(v1,x2,a_input) == 0,...
            subs(v3_d,x1,L-a_input) == -(subs(v1_d,x2,a_input)),...
            subs(v3,x1,L-a_max)==subs(v5,x1,L-a_max),...
            subs(v3_d,x1,L-a_max)==subs(v5_d,x1,L-a_max),...
            subs(v6,x2,x_contact)==subs(v1,x2,x_contact),...
            subs(v6_d,x2,x_contact)==subs(v1_d,x2,x_contact)];
    S_C = solve(eqns,[C1 C2 C5 C6 C9 C10 C11 C12]);

     %% get V6 full analyticaly equation
     v6_d_equation = subs(v6_d,C11,S_C.C11);
     v6_equation = subs(v6,C11,S_C.C11);
     v6_equation = subs(v6_equation,C12,S_C.C12);

    %% get V1 full analyticaly equation and find the x_contact
    v1_d_equation = subs(v1_d,C1,S_C.C1);
    v1_equation = subs(v1,C1,S_C.C1);
    v1_equation = subs(v1_equation,C2,S_C.C2);
    
    % the core is here: finding the x_contact is finding "slope=tan(rollingangle)"
    v1_d_equation_Sub = subs(v1_d_equation,x2,x_contact);
    v1_d_equation_FINDX = [v1_d_equation_Sub == tan(rolling_angle_input*pi/180)];
    assume(x_contact <= a_input & x_contact >= L-c)
    x_contact_v1 = double(solve(v1_d_equation_FINDX,x_contact));

    % make sure only take the first solution, if the solution is nonempty 
    % (MATLAB somtimes gives a array with complex number)
    if (~isempty(x_contact_v1))  && (length(x_contact_v1)~=1)
        x_contact_v1=x_contact_v1(1);
    end
    
    % make sure the solution satisfies the range (x_contact at untaper part) 
    if (~isempty(x_contact_v1))  &&  ((x_contact_v1<=a_input) && (x_contact_v1>=L-c))
        fprintf('* Fulcrum at untaper part and x_contact at untaper part.\n');
        x_contact_output=x_contact_v1;
        Fulcrum_contactforce=2; %'Fulcrum AT untaper + contact force AT untaper';
    end

    %% get V3 full analyticaly equation
     v3_d_equation = subs(v3_d,C5,S_C.C5);
     v3_equation = subs(v3,C5,S_C.C5);
     v3_equation = subs(v3_equation,C6,S_C.C6);

    %% get V5 full analyticaly equation
     v5_d_equation = subs(v5_d,C9,S_C.C9);
     v5_equation = subs(v5,C9,S_C.C9);
     v5_equation = subs(v5_equation,C10,S_C.C10);
end

%% 3: use except V1 (when fulcrum at taper part) and (the contact point must at taper part) 
if ~((a_input>=(L-c)) && (a_input<=a_max)) && (c~=L) % if c=L then this part is impossible (no taper)
    %% get constants: create the ten boundry conditions equations. See the Core writeups
    eqns = [subs(v5,x1,0) == 0,...
            subs(v4,x1,L-a_input) == 0,...
            subs(v2,x2,a_input) == 0,...
            subs(v4_d,x1,L-a_input) == -(subs(v2_d,x2,a_input))...
            subs(v3,x1,c)==subs(v4,x1,c),...
            subs(v3_d,x1,c)==subs(v4_d,x1,c),...
            subs(v3,x1,L-a_max)==subs(v5,x1,L-a_max),...
            subs(v3_d,x1,L-a_max)==subs(v5_d,x1,L-a_max),...
            subs(v6,x2,x_contact)==subs(v2,x2,x_contact),...
            subs(v6_d,x2,x_contact)==subs(v2_d,x2,x_contact)];
    S_C = solve(eqns,[C3 C4 C5 C6 C7 C8 C9 C10 C11 C12]);

    %% get V6 full analyticaly equation
    v6_d_equation = subs(v6_d,C11,S_C.C11);
    v6_equation = subs(v6,C11,S_C.C11);
    v6_equation = subs(v6_equation,C12,S_C.C12);

    %% get V2 full analyticaly equation and find the x_contact
    v2_d_equation = subs(v2_d,C3,S_C.C3);
    v2_equation = subs(v2,C3,S_C.C3);
    v2_equation = subs(v2_equation,C4,S_C.C4);
    
    % the core is here: finding the x_contact is finding "slope=tan(rollingangle)"
    v2_d_equation_Sub = subs(v2_d_equation,x2,x_contact);
    v2_d_equation_FINDX = [v2_d_equation_Sub == tan(rolling_angle_input*pi/180)];
    assume(x_contact >= 0 & x_contact <= a_input)
    x_contact_v2 = double(solve(v2_d_equation_FINDX,x_contact));
    
    % make sure only take the first solution, if the solution is nonempty 
    % (MATLAB somtimes gives a array with complex number)
    if (~isempty(x_contact_v2))  && (length(x_contact_v2)~=1)
        x_contact_v2=x_contact_v2(1);
    end
    
    % make sure the solution satisfies the range (x_contact at taper part)
    if (~isempty(x_contact_v2))  &&  ((x_contact_v2<=a_input) && (x_contact_v2>=0))
        fprintf('* Fulcrum at taper part and x_contact at taper part.\n');
        x_contact_output=x_contact_v2;
        Fulcrum_contactforce=3; %'Fulcrum at taper part + contact point must at taper part';
    end

    %% get V4 full analyticaly equation
    v4_d_equation = subs(v4_d,C7,S_C.C7);
    v4_equation = subs(v4,C7,S_C.C7);
    v4_equation = subs(v4_equation,C8,S_C.C8);

    %% get V3 full analyticaly equation
    v3_d_equation = subs(v3_d,C5,S_C.C5);
    v3_equation = subs(v3,C5,S_C.C5);
    v3_equation = subs(v3_equation,C6,S_C.C6);

    %% get V5 full analyticaly equation
    v5_d_equation = subs(v5_d,C9,S_C.C9);
    v5_equation = subs(v5,C9,S_C.C9);
    v5_equation = subs(v5_equation,C10,S_C.C10);
end

%% 4: when the load is not large enough, the contact point is at toe/heel point
if Fulcrum_contactforce==4
    x_contact_output=0;
end

%% find the deflection at the x_contact
% case when not normal (rolling_angle and P both be zero: stage3 for hindfoot; stage1 for forefoot)
if rolling_angle_input==0 && P_input==0
    x_contact_output=0;
    deflectionATContact_output=0;
end

% case when normal (contact point is not at toe/heel)
if (Fulcrum_contactforce==1 ||... %'Fulcrum AT untaper + contactforce AT taper'
   Fulcrum_contactforce==2||... %'Fulcrum AT untaper + contactforce AT untaper'
   Fulcrum_contactforce==3)... %'Fulcrum at taper part + Contact point must at taper part'
   &&(~(rolling_angle_input==0 && P_input==0))

    deflectionATContact_output=feval(matlabFunction(subs(v6_equation,x_contact,x_contact_output)),x_contact_output);
end

% case when contact point is at toe/heel
if Fulcrum_contactforce==4  &&(~(rolling_angle_input==0 && P_input==0))
    if P_input ==0 % this is probably only for the start and end of whole stages
        deflectionATContact_output=0;
    else % when the load is not big enough, the contact point still at the toe: v6 is just a constant!
        deflectionATContact_output=double(subs(S_C.C12,x_contact,x_contact_output));
    end
end
end