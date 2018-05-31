%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% figure_5B.m
%
% This is the script to create Figure 5B in Insel, Guerguiev and Richards (2018).
% Parameters controlling the simulations are given in the start of the main_script.m
% file, which also runs the simulations.

y_max = 3;
y_min = -3;

figure;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ---- Comparisons --------------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ---- Control ------------------------------------------------------------------%

CS1_val = [];

for n = 1:num_trials
    CS1_val(n) = 0;
    for i=0:3
        last_CS1_time = all_CS1_times.('control')(n, end-i); % get the last CS1 presentation

        CS1_val(n) = CS1_val(n) + nanmean(max_y.('control')(n, last_CS1_time:last_CS1_time+CS1_L/dt));
    end
    CS1_val(n) = CS1_val(n)/4;
end

% plot data
bar([1], [nanmean(CS1_val)], 'FaceColor', [0, 0, 0]);
hold on;
if nanmean(CS1_val) > 0
    errorbar([1], [nanmean(CS1_val)], [0], [nanstd(CS1_val)], 'k');
else
    errorbar([1], [nanmean(CS1_val)], [nanstd(CS1_val)], [0], 'k');
end
axis([0, 9, y_min, y_max]);
hold on;

% ---- Control pre-exposure -----------------------------------------------------%

for n = 1:num_trials
    CS1_val(n) = 0;
    for i=0:3
        last_CS1_time = all_CS1_times.('control_preexposure')(n, end-i); % get the last CS1 presentation

        CS1_val(n) = CS1_val(n) + nanmean(max_y.('control_preexposure')(n, last_CS1_time:last_CS1_time+CS1_L/dt));
    end
    CS1_val(n) = CS1_val(n)/4;
end

% plot data
bar([2], [nanmean(CS1_val)], 'FaceColor', [1, 1, 1]);
hold on;
if nanmean(CS1_val) > 0
    errorbar([2], [nanmean(CS1_val)], [0], [nanstd(CS1_val)], 'k');
else
    errorbar([2], [nanmean(CS1_val)], [nanstd(CS1_val)], [0], 'k');
end
hold on;

% ---- Conditioning -20% inhibition ---------------------------------------------%

for n = 1:num_trials
    CS1_val(n) = 0;
    for i=0:3
        last_CS1_time = all_CS1_times.('inhibition_conditioning')(n, end-i); % get the last CS1 presentation

        CS1_val(n) = CS1_val(n) + nanmean(max_y.('inhibition_conditioning')(n, last_CS1_time:last_CS1_time+CS1_L/dt));
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
hold on;

% ---- Conditioning -20% inhibition pre-exposure --------------------------------%

for n = 1:num_trials
    CS1_val(n) = 0;
    for i=0:3
        last_CS1_time = all_CS1_times.('inhibition_conditioning_preexposure')(n, end-i); % get the last CS1 presentation

        CS1_val(n) = CS1_val(n) + nanmean(max_y.('inhibition_conditioning_preexposure')(n, last_CS1_time:last_CS1_time+CS1_L/dt));
    end
    CS1_val(n) = CS1_val(n)/4;
end

% plot data
bar([5], [nanmean(CS1_val)], 'FaceColor', [1, 1, 1]);
hold on;
if nanmean(CS1_val) > 0
    errorbar([5], [nanmean(CS1_val)], [0], [nanstd(CS1_val)], 'k');
else
    errorbar([5], [nanmean(CS1_val)], [nanstd(CS1_val)], [0], 'k');
end
hold on;

% ---- Test -20% inhibition -----------------------------------------------------%

for n = 1:num_trials
    CS1_val(n) = 0;
    for i=0:3
        last_CS1_time = all_CS1_times.('inhibition_test')(n, end-i); % get the last CS1 presentation

        CS1_val(n) = CS1_val(n) + nanmean(max_y.('inhibition_test')(n, last_CS1_time:last_CS1_time+CS1_L/dt));
    end
    CS1_val(n) = CS1_val(n)/4;
end

% plot data
bar([7], [nanmean(CS1_val)], 'FaceColor', [0, 0, 0]);
hold on;
hold on;
if nanmean(CS1_val) > 0
    errorbar([7], [nanmean(CS1_val)], [0], [nanstd(CS1_val)], 'k');
else
    errorbar([7], [nanmean(CS1_val)], [nanstd(CS1_val)], [0], 'k');
end
hold on;

% ---- Test -20% inhibition pre-exposure ----------------------------------------%

for n = 1:num_trials
    CS1_val(n) = 0;
    for i=0:3
        last_CS1_time = all_CS1_times.('inhibition_test_preexposure')(n, end-i); % get the last CS1 presentation

        CS1_val(n) = CS1_val(n) + nanmean(max_y.('inhibition_test_preexposure')(n, last_CS1_time:last_CS1_time+CS1_L/dt));
    end
    CS1_val(n) = CS1_val(n)/4;
end

% plot data
bar([8], [nanmean(CS1_val)], 'FaceColor', [1, 1, 1]);
hold on;
if nanmean(CS1_val) > 0
    errorbar([8], [nanmean(CS1_val)], [0], [nanstd(CS1_val)], 'k');
else
    errorbar([8], [nanmean(CS1_val)], [nanstd(CS1_val)], [0], 'k');
end
hold on;

% save figure
print('figure_5B', '-dpng');
print('figure_5B', '-dsvg');