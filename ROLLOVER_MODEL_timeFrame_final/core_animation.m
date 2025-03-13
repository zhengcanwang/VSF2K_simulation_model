function [deflection_total_output,xplot_total_output,... % deflection for whole keel
          deflection_x_contact_output,xplot_x_contact_output,...% deflection at x_contact
          deflection_a_output,xplot_a_output]...% deflection at fulcrum
            =core_animation(a, P_input, x_contact_input, hindORfore, n_points)
% this core is used to compute how the keel deflects
% input in meter, N, and meter
%% load the design
if hindORfore == "hind"
    HindFoot_design;
end
if hindORfore == "fore"
    ForeFoot_design;
end

%% load some symbols
syms x1 x2 C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 C12 hh bb
warning('off')

%% three condition when solving for how it deflect:
% 1: use except V4 (when fulcrum at untaper part) and (when contact point at taper part)
% 2: use except V4 and V2 (when fulcrum at untaper part) and (when contact point at untaper part)
% 3: use except V1 (when fulcrum at taper part) and (the contact point must at taper part)  

%% write up the V for each section. See the Core writeups
% V1(x2,C1,C2)：Right of fulcrum + (L-c)_To_a + untaper
hh = h_max;
bb = 6*P_max*x2/(n*TS*hh^2);
if bb_constant==1
    bb=bb_constant_value;
end
M = P_input*(x_contact_input-x2);
v1_dd = 12*M/E*(1/(bb*hh^3));

% V2(x2,C3,C4)：Right of fulcrum + Xcontact_To_(L-c) + taper
hh=h_min+(h_max-h_min)*x2/(L-c);
bb=6*P_max*x2/(n*TS*(hh)^2);
if bb_constant==1
    bb=bb_constant_value;
end
M = P_input*(x_contact_input-x2);
v2_dd = 12*M/E*(1/(bb*hh^3));

% V6(x2,C11,C12)：Right of fulcrum + 0_To_Xcontact + taper/untaper
v6_dd = 0;

% V5(x1,C9,C10)：Left of fulcrum + 0_To_(L-a_max) + untaper
hh=h_max;
bb=6*(a_max/(L-a_max))*P_max*x1/(n*TS*hh^2);
if bb_constant==1
    bb=bb_constant_value;
end
M = -((a-x_contact_input)/(L-a))*P_input*x1;
v5_dd = 12*M/E*(1/(bb*hh^3));

% V3(x1,C5,C6)：Left of fulcrum + (L-a_max)_To_c + untaper
hh=h_max;
bb=6*P_max*(L-x1)/(n*TS*hh^2);
if bb_constant==1
    bb=bb_constant_value;
end
M = -((a-x_contact_input)/(L-a))*P_input*x1;
v3_dd = 12*M/E*(1/(bb*hh^3));

% V4(x1,C7,C8)：Left of fulcrum + c_To_(L-a) + taper
hh=h_min+(h_max-h_min)*(L-x1)/(L-c);
bb=6*P_max*(L-x1)/(n*TS*(hh)^2);
if bb_constant==1
    bb=bb_constant_value;
end
M = -((a-x_contact_input)/(L-a))*P_input*x1;
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

%% Start solving for x_contact: total three conditions:
%% 1: use except V4 (when fulcrum at untaper part) and (when contact point at taper part)
if (a>=(L-c)) && (a<=a_max) && (x_contact_input<=(L-c)) && (c~=L) % if c=L then this part is impossible (no taper)
    %% get constants: create the ten boundry conditions equations. See the Core writeups
    eqns = [subs(v5,x1,0) == 0,...
            subs(v3,x1,L-a) == 0,...
            subs(v1,x2,a) == 0,...
            subs(v3_d,x1,L-a) == -(subs(v1_d,x2,a)),...
            subs(v1,x2,L-c)==subs(v2,x2,L-c),...
            subs(v1_d,x2,L-c)==subs(v2_d,x2,L-c),...
            subs(v3,x1,L-a_max)==subs(v5,x1,L-a_max),...
            subs(v3_d,x1,L-a_max)==subs(v5_d,x1,L-a_max),...
            subs(v6,x2,x_contact_input)==subs(v2,x2,x_contact_input),...
            subs(v6_d,x2,x_contact_input)==subs(v2_d,x2,x_contact_input)];
    S_C = solve(eqns,[C1 C2 C3 C4 C5 C6 C9 C10 C11 C12]);

     %% get V6 full analyticaly equation
     v6_d_equation = subs(v6_d,C11,S_C.C11);
     v6_equation = subs(v6,C11,S_C.C11);
     v6_equation = subs(v6_equation,C12,S_C.C12);

    %% get V2 full analyticaly equation
    v2_d_equation = subs(v2_d,C3,S_C.C3);
    v2_equation = subs(v2,C3,S_C.C3);
    v2_equation = subs(v2_equation,C4,S_C.C4);

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

     %% get the defelection for the whole keel for this condition
    deflection_total_output=[]; % initialize the array for deflection at the "undeflected heel/toe coordinate"
    xplot_total_output=[];
    for xplot=linspace(0,x_contact_input,n_points)
        v6_equation_double=double(subs(v6_equation,x2,xplot));
        deflection_total_output=[deflection_total_output,v6_equation_double];
        xplot_total_output=[xplot_total_output,xplot];
    end
    
    % Also seperately get the defelection for the x_contact for this condition
    deflection_x_contact_output=deflection_total_output(end);
    xplot_x_contact_output=xplot_total_output(end);
    
    for xplot=linspace(x_contact_input,L-c,n_points)
        v2_equation_double=double(subs(v2_equation,x2,xplot));
        deflection_total_output=[deflection_total_output,v2_equation_double];
        xplot_total_output=[xplot_total_output,xplot];
    end
    for xplot=linspace(L-c,a,n_points)
        v1_equation_double=double(subs(v1_equation,x2,xplot));
        deflection_total_output=[deflection_total_output,v1_equation_double];
        xplot_total_output=[xplot_total_output,xplot];
    end
    
    % Also seperately get the defelection for the fulcrum for this condition
    deflection_a_output=deflection_total_output(end);
    xplot_a_output=xplot_total_output(end);
    
    for xplot=linspace(a,a_max,n_points)
        v3_equation_double=double(subs(v3_equation,x1,L-xplot));
        deflection_total_output=[deflection_total_output,v3_equation_double];
        xplot_total_output=[xplot_total_output,xplot];
    end
    for xplot=linspace(a_max,L,n_points)
        v5_equation_double=double(subs(v5_equation,x1,L-xplot));
        deflection_total_output=[deflection_total_output,v5_equation_double];
        xplot_total_output=[xplot_total_output,xplot];
    end
end

%% 2: use except V4 and V2 (when fulcrum at untaper part) and (when contact point at untaper part)
if ((a>=(L-c)) && (a<=a_max)) && (x_contact_input>=(L-c)) && (x_contact_input<=a)
    %% get constants: create the eight boundry conditions equations. See the Core writeups
    eqns = [subs(v5,x1,0) == 0,...
            subs(v3,x1,L-a) == 0,...
            subs(v1,x2,a) == 0,...
            subs(v3_d,x1,L-a) == -(subs(v1_d,x2,a)),...
            subs(v3,x1,L-a_max)==subs(v5,x1,L-a_max),...
            subs(v3_d,x1,L-a_max)==subs(v5_d,x1,L-a_max),...
            subs(v6,x2,x_contact_input)==subs(v1,x2,x_contact_input),...
            subs(v6_d,x2,x_contact_input)==subs(v1_d,x2,x_contact_input)];
    S_C = solve(eqns,[C1 C2 C5 C6 C9 C10 C11 C12]);

     %% get V6 full analyticaly equation
     v6_d_equation = subs(v6_d,C11,S_C.C11);
     v6_equation = subs(v6,C11,S_C.C11);
     v6_equation = subs(v6_equation,C12,S_C.C12);

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

     %% get the defelection for the whole keel for this condition
    deflection_total_output=[]; % initialize the array for deflection at the "undeflected heel/toe coordinate"
    xplot_total_output=[];
    for xplot=linspace(0,x_contact_input,n_points)
        v6_d_equation_double=double(subs(v6_d_equation,x2,xplot));
        v6_equation_double=double(subs(v6_equation,x2,xplot));
        deflection_total_output=[deflection_total_output,v6_equation_double];
        xplot_total_output=[xplot_total_output,xplot];
        v6_total=[v6_total,v6_d_equation_double];
    end
    
    % Also seperately get the defelection for the x_contact for this condition
    deflection_x_contact_output=deflection_total_output(end);
    xplot_x_contact_output=xplot_total_output(end);
    
    for xplot=linspace(x_contact_input,a,n_points)
        v1_equation_double=double(subs(v1_equation,x2,xplot));
        deflection_total_output=[deflection_total_output,v1_equation_double];
        xplot_total_output=[xplot_total_output,xplot];
    end
    
    % Also seperately get the defelection for the fulcrum for this condition
    deflection_a_output=deflection_total_output(end);
    xplot_a_output=xplot_total_output(end);
    
    for xplot=linspace(a,a_max,n_points)
        v3_equation_double=double(subs(v3_equation,x1,L-xplot));
        deflection_total_output=[deflection_total_output,v3_equation_double];
        xplot_total_output=[xplot_total_output,xplot];
    end
    for xplot=linspace(a_max,L,n_points)
        v5_equation_double=double(subs(v5_equation,x1,L-xplot));
        deflection_total_output=[deflection_total_output,v5_equation_double];
        xplot_total_output=[xplot_total_output,xplot];
    end
end

%% 3: use except V1 (when fulcrum at taper part) and (the contact point must at taper part) 
if ~((a>=(L-c)) && (a<=a_max)) && (c~=L) % if c=L then this part is impossible (no taper)
    %% get constants: create the ten boundry conditions equations. See the Core writeups
    eqns = [subs(v5,x1,0) == 0,...
            subs(v4,x1,L-a) == 0,...
            subs(v2,x2,a) == 0,...
            subs(v4_d,x1,L-a) == -(subs(v2_d,x2,a))...
            subs(v3,x1,c)==subs(v4,x1,c),...
            subs(v3_d,x1,c)==subs(v4_d,x1,c),...
            subs(v3,x1,L-a_max)==subs(v5,x1,L-a_max),...
            subs(v3_d,x1,L-a_max)==subs(v5_d,x1,L-a_max),...
            subs(v6,x2,x_contact_input)==subs(v2,x2,x_contact_input),...
            subs(v6_d,x2,x_contact_input)==subs(v2_d,x2,x_contact_input)];
    S_C = solve(eqns,[C3 C4 C5 C6 C7 C8 C9 C10 C11 C12]);

    %% get V6 full analyticaly equation
    v6_d_equation = subs(v6_d,C11,S_C.C11);
    v6_equation = subs(v6,C11,S_C.C11);
    v6_equation = subs(v6_equation,C12,S_C.C12);

    %% get V2 full analyticaly equation
    v2_d_equation = subs(v2_d,C3,S_C.C3);
    v2_equation = subs(v2,C3,S_C.C3);
    v2_equation = subs(v2_equation,C4,S_C.C4);

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

    %% get the defelection for the whole keel for this condition
    deflection_total_output=[]; % initialize the array for deflection at the "undeflected heel/toe coordinate"
    xplot_total_output=[];
   for xplot=linspace(0,x_contact_input,n_points)
        v6_d_equation_double=double(subs(v6_d_equation,x2,xplot));
        v6_equation_double=double(subs(v6_equation,x2,xplot));
        deflection_total_output=[deflection_total_output,v6_equation_double];
        xplot_total_output=[xplot_total_output,xplot];
    end
    
    % Also seperately get the defelection for the x_contact for this condition
    deflection_x_contact_output=deflection_total_output(end);
    xplot_x_contact_output=xplot_total_output(end);
    
    for xplot=linspace(x_contact_input,a,n_points)
        v2_equation_double=double(subs(v2_equation,x2,xplot));
        deflection_total_output=[deflection_total_output,v2_equation_double];
        xplot_total_output=[xplot_total_output,xplot];
    end
    
    % Also seperately get the defelection for the fulcrum for this condition
    deflection_a_output=deflection_total_output(end);
    xplot_a_output=xplot_total_output(end);
    
    for xplot=linspace(a,L-c,n_points)
        v4_equation_double=double(subs(v4_equation,x1,L-xplot));
        deflection_total_output=[deflection_total_output,v4_equation_double];
        xplot_total_output=[xplot_total_output,xplot];
    end
    for xplot=linspace(L-c,a_max,n_points)
        v3_equation_double=double(subs(v3_equation,x1,L-xplot));
        deflection_total_output=[deflection_total_output,v3_equation_double];
        xplot_total_output=[xplot_total_output,xplot];
    end
    for xplot=linspace(a_max,L,n_points)
        v5_equation_double=double(subs(v5_equation,x1,L-xplot));
        deflection_total_output=[deflection_total_output,v5_equation_double];
        xplot_total_output=[xplot_total_output,xplot];
    end
end

%% make them into vector
deflection_total_output=deflection_total_output';
xplot_total_output=xplot_total_output';
end