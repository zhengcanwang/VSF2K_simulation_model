%% At the beginning, get the the foot-angle and the toe-angle at the start of StageTwo (foot-flat i.e.FF) and the load
S_FF_START=fsolve(@(x) FIND_StartFootFlat(x,theta_hind_offset,theta_fore_offset,a_hind) ,[-8*pi/180, 10*pi/180],option);
footangle_FF_start=S_FF_START(1)*180/pi; % get the footangle when foot-flat starts
toeangle_FF=S_FF_START(2)*180/pi; % get the toeangle when foot-flat starts

%[~,yy]=FIND_StartFootFlat([S(1),S(2)]); %get yy (a temp variable for geometry calculation)

% find the load
P_start_FF = ISOAngle2Force(footangle_FF_start*pi/180); % angle should be in rad

%% At the beginning, get the the foot-angle and the hind-foot angle at end of foot-flat and the load
S_FF_END=fsolve(@(x)FIND_ENDFootFlat_angles(x,theta_hind_offset,theta_fore_offset,a_fore),[8*pi/180, 20*pi/180],option);
footangle_FF_END=S_FF_END(1)*180/pi;
heelangle_FF=S_FF_END(2)*180/pi;

%[~,mm]=FIND_ENDFootFlat_angles([S(1),S(2)]); %get mm (a temp variable for geometry calculation)

% find the load
P_end_FF = ISOAngle2Force(footangle_FF_END*pi/180); % angle should be in rad

%% Before going StageTwo: find that boundary angle and the load between stage 2.1 and 2.2
S_boundary=fsolve(@(x) FIND_boundaryofFF_from_firstHalf(x,theta_hind_offset,theta_fore_offset,a_fore,a_hind) ,[1*pi/180,300/1000],option);
% SS_boundary_=fsolve(@(x) FIND_boundaryofFF_from_secondHalf(x,theta_hind_offset,theta_fore_offset,a_fore,a_hind) ,[1*pi/180,300/1000],option);
% these two above should give the same!
footangle_FF_boundary=S_boundary(1)*180/pi;

% get the shift (distance between fix-toe and fix-heel) at the mid of stage 2
shift_FF_boundary=S_boundary(2);

% find the load
P_boundary_FF = ISOAngle2Force(footangle_FF_boundary*pi/180); % angle should be in rad