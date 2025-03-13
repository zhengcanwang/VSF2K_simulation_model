%% Set up the time array from ISO standard 0-600ms
time_array = linspace(0,600,301); % time step in 2 ms 
for i=1:1:length(time_array)
    foot_angle_array_timeFrame(i)=ISOTime2Angle(time_array(i));
end

%% Set up the angle input from ISO standard
foot_angle_veryInitial=foot_angle_array_timeFrame(1);
foot_angle_veryEnd=foot_angle_array_timeFrame(end); 

%% Option for the fsolve()
option = optimset('TolFun',1e-14,'MaxFunEvals',1e5,'Maxiter',1e5,'Display','final');
