%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% figure_6B.m
%
% This is the script to create Figure 6B in Insel, Guerguiev and Richards (2018).
% Parameters controlling the simulations are given in the start of the main_script.m
% file, which also runs the simulations.

y_max = 1;
y_min = 0;

figure;

% ---- Base ---------------------------------------------------------------------%

mean_y_base = [];

for n = 1:num_trials
    mean_y_base(n) = 0;
    for i = 1:108
        inhibition_stim_time = all_inhibition_stim_times.('inhibition')(n, i); % get the time of stimulation
    
        mean_y_base(n) = mean_y_base(n) + nanmean(max_y.('inhibition')(n, inhibition_stim_time-stim_D/dt:inhibition_stim_time-1));
    end
    mean_y_base(n) = mean_y_base(n)/108;
end

% plot data
bar([1], [nanmean(mean_y_base)], 'FaceColor', [0, 0, 0]);
hold on;
if nanmean(mean_y_base) > 0
    errorbar([1], [nanmean(mean_y_base)], [0], [nanstd(mean_y_base)], 'k');
else
    errorbar([1], [nanmean(mean_y_base)], [nanstd(mean_y_base)], [0], 'k');
end

% ---- Base -20% inhibition -----------------------------------------------------%

mean_y_base_inhib = [];

for n = 1:num_trials
    mean_y_base_inhib(n) = 0;
    for i = 1:108
        inhibition_stim_time = all_inhibition_stim_times.('inhibition')(n, i); % get the time of stimulation
    
        mean_y_base_inhib(n) = mean_y_base_inhib(n) + nanmean(max_y.('inhibition')(n, inhibition_stim_time:inhibition_stim_time + stim_L/dt));
    end
    mean_y_base_inhib(n) = mean_y_base_inhib(n)/108;
end

% plot data
bar([2], [nanmean(mean_y_base_inhib)], 'FaceColor', [1, 0.8, 0]);
hold on;
if nanmean(mean_y_base_inhib) > 0
    errorbar([2], [nanmean(mean_y_base_inhib)], [0], [nanstd(mean_y_base_inhib)], 'k');
else
    errorbar([2], [nanmean(mean_y_base_inhib)], [nanstd(mean_y_base_inhib)], [0], 'k');
end

% ---- Extinction ---------------------------------------------------------------%

CS1_val = [];

for n = 1:num_trials
    CS1_val(n) = 0;
    for i = 10:13
        CS1_time = all_CS1_times.('inhibition')(n, i); % get the CS1 presentation
    
        CS1_val(n) = CS1_val(n) + nanmean(max_y.('inhibition')(n, CS1_time:CS1_time+CS1_L/dt));
    end
    CS1_val(n) = CS1_val(n)/4;
end

% plot data
bar([4], [nanmean(CS1_val)], 'FaceColor', [0, 0, 0]);
hold on;
if nanmean(CS1_val) > 0
    errorbar([4], [nanmean(CS1_val)], [0], [nanstd(CS1_val)], 'k');
else
    errorbar([4], [nanmean(CS1_val)], [nanstd(CS1_val)], [0], 'k');
end

CS1_val = [];

for n = 1:num_trials
    CS1_val(n) = 0;
    for i = 14:17
        CS1_time = all_CS1_times.('inhibition')(n, i); % get the CS1 presentation
    
        CS1_val(n) = CS1_val(n) + nanmean(max_y.('inhibition')(n, CS1_time:CS1_time+CS1_L/dt));
    end
    CS1_val(n) = CS1_val(n)/4;
end

% plot data
bar([5], [nanmean(CS1_val)], 'FaceColor', [0, 0, 0]);
hold on;
if nanmean(CS1_val) > 0
    errorbar([5], [nanmean(CS1_val)], [0], [nanstd(CS1_val)], 'k');
else
    errorbar([5], [nanmean(CS1_val)], [nanstd(CS1_val)], [0], 'k');
end

CS1_val = [];

for n = 1:num_trials
    CS1_val(n) = 0;
    for i = 18:21
        CS1_time = all_CS1_times.('inhibition')(n, i); % get the CS1 presentation
    
        CS1_val(n) = CS1_val(n) + nanmean(max_y.('inhibition')(n, CS1_time:CS1_time+CS1_L/dt));
    end
    CS1_val(n) = CS1_val(n)/4;
end

% plot data
bar([6], [nanmean(CS1_val)], 'FaceColor', [0, 0, 0]);
hold on;
if nanmean(CS1_val) > 0
    errorbar([6], [nanmean(CS1_val)], [0], [nanstd(CS1_val)], 'k');
else
    errorbar([6], [nanmean(CS1_val)], [nanstd(CS1_val)], [0], 'k');
end

% ---- CS1 & -20% inhibition ----------------------------------------------------%

CS1_val = [];

for n = 1:num_trials
    CS1_val(n) = 0;
    for i = 22:25
        CS1_time = all_CS1_times.('inhibition')(n, i); % get the last CS1 presentation
    
        CS1_val(n) = CS1_val(n) + mean(max_y.('inhibition')(n, CS1_time:CS1_time+CS1_L/dt));
    end
    CS1_val(n) = CS1_val(n)/4;
end

% plot data
bar([8], [nanmedian(CS1_val)], 'FaceColor', [1, 0.8, 0]);
hold on;
if nanmedian(CS1_val) > 0
    errorbar([8], [nanmedian(CS1_val)], [0], [nanstd(CS1_val)], 'k');
else
    errorbar([8], [nanmedian(CS1_val)], [nanstd(CS1_val)], [0], 'k');
end

% ---- Post-FC CS1 --------------------------------------------------------------%

CS1_val = [];

for n = 1:num_trials
    CS1_val(n) = 0;
    for i = 10:13
        CS1_time = all_CS1_times.('excitation')(n, i); % get the last CS1 presentation
    
        CS1_val(n) = CS1_val(n) + nanmean(max_y.('excitation')(n, CS1_time:CS1_time+CS1_L/dt));
    end
    CS1_val(n) = CS1_val(n)/4;
end

% plot data
bar([10], [nanmean(CS1_val)], 'FaceColor', [0, 0, 0]);
hold on;
if nanmean(CS1_val) > 0
    errorbar([10], [nanmean(CS1_val)], [0], [nanstd(CS1_val)], 'k');
else
    errorbar([10], [nanmean(CS1_val)], [nanstd(CS1_val)], [0], 'k');
end

% ---- Post-FC CS1 & +10% inhibition --------------------------------------------%

CS1_val = [];

for n = 1:num_trials
    CS1_val(n) = 0;
    for i = 14:17
        CS1_time = all_CS1_times.('excitation')(n, i); % get the last CS1 presentation
    
        CS1_val(n) = CS1_val(n) + nanmean(max_y.('excitation')(n, CS1_time:CS1_time+CS1_L/dt));
    end
    CS1_val(n) = CS1_val(n)/4;
end

% plot data
bar([11], [nanmean(CS1_val)], 'FaceColor', [0, 0.8, 1]);
hold on;
if nanmean(CS1_val) > 0
    errorbar([11], [nanmean(CS1_val)], [0], [nanstd(CS1_val)], 'k');
else
    errorbar([11], [nanmean(CS1_val)], [nanstd(CS1_val)], [0], 'k');
end

axis([0, 12, y_min, y_max]);

% save figure
print('figure_6B', '-dpng');
print('figure_6B', '-dsvg');