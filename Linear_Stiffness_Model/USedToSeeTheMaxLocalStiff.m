clc;clear;close all
load stiffness_local.mat
%%
for m=1:1:4
    max_array_array=[];
    for j=m*4-3:1:4*m
        max_array=[];
        for i=1:1:21
            max_array=[max_array,max(stiffness_local_lookup_hind{j,i})];
        end
        max_array_array=[max_array_array,max(max_array)]
    end
    max_each_hind(m)=max(max_array_array);
end

for m=1:1:4
    max_array_array=[];
    for j=[m,m+4,m+8,m+12]
        max_array=[];
        for i=1:1:21
            max_array=[max_array,max(stiffness_local_lookup_hind{j,i})];
        end
        max_array_array=[max_array_array,max(max_array)]
    end
    max_each_fore(m)=max(max_array_array);
end
