clc;clear;close all;
stiffness_local_lookup_hind=cell(16,21);
stiffness_local_lookup_fore=cell(16,21);

for iiii=-10:1:10
    %% each folder name
    folder_gold=strcat(['E:\VSF2K_Final\data_TimeFrame_withCOS_FINAL\alignment_',num2str(iiii)]);
    
    %% for each folder    
    % Get a list of all .mat files in the folder
    mat_files_gold = dir(fullfile(folder_gold, '*.mat'));

    %% Loop through each .mat file of the second half
    for kkkk = 1:1:length(mat_files_gold)/2
        % Get the full path of the .mat file
        file_path_gold = fullfile(folder_gold, mat_files_gold(kkkk).name);
        
        % Load the .mat file
        load(file_path_gold);
        close all;

        
        %% the staffs:
        stiffness_local_lookup_hind{kkkk,iiii+11}=[load_hind_stage21,load_hind_stage22]';
        stiffness_local_lookup_fore{kkkk,iiii+11}=[load_fore_stage21,load_fore_stage22]';
    end
end
save("stiffness_local.mat","stiffness_local_lookup_hind","stiffness_local_lookup_fore")