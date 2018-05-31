%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% figure_3D.m
%
% This is the script to create Figure 3D in Insel, Guerguiev and Richards (2018).
% Parameters controlling the simulations are given in the start of the main_script.m
% file, which also runs the simulations.

y_max = 0.8;
y_min = -0.6;

exp_name = ('x_I');

figure;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ---- Weight update rule comparisons -------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% x_I results

CS1_excitatory_responses = [];
CS2_excitatory_responses = [];
CS1_val = [];
CS2_val = [];

for n = 1:num_trials
    last_CS1_time = all_CS1_times.(exp_name)(n, end); % get the last CS1 presentation
    last_CS2_time = all_CS2_times.(exp_name)(n, end); % get the last CS2 presentation

    CS1_val(n) = nanmean(mean_phi_E.(exp_name)(n, last_CS1_time:last_CS1_time+CS1_L/dt));
    CS2_val(n) = nanmean(mean_phi_E.(exp_name)(n, last_CS2_time:last_CS2_time+CS2_L/dt));
end

% plot data
bar([1], [nanmean(CS1_val - CS2_val)], 'FaceColor', [0, 0, 0]);
hold on;
if nanmean(CS1_val - CS2_val) > 0
    errorbar([1], [nanmean(CS1_val - CS2_val)], [0], [nanstd(CS1_val - CS2_val)], 'k');
else
    errorbar([1], [nanmean(CS1_val - CS2_val)], [nanstd(CS1_val - CS2_val)], [0], 'k');
end
axis([0, 9, y_min, y_max]);
hold on;

% x_I_inhib results

for n = 1:num_trials
    last_CS1_time = all_CS1_times.('x_I_inhib')(n, end); % get the last CS1 presentation
    last_CS2_time = all_CS2_times.('x_I_inhib')(n, end); % get the last CS2 presentation

    CS1_val(n) = nanmean(mean_phi_E.('x_I_inhib')(n, last_CS1_time:last_CS1_time+CS1_L/dt));
    CS2_val(n) = nanmean(mean_phi_E.('x_I_inhib')(n, last_CS2_time:last_CS2_time+CS2_L/dt));
end

% plot data
bar([2], [nanmean(CS1_val - CS2_val)], 'FaceColor', [0.6, 0.6, 0.6]);
hold on;
if nanmean(CS1_val - CS2_val) > 0
    errorbar([2], [nanmean(CS1_val - CS2_val)], [0], [nanstd(CS1_val - CS2_val)], 'k');
else
    errorbar([2], [nanmean(CS1_val - CS2_val)], [nanstd(CS1_val - CS2_val)], [0], 'k');
end
hold on;

% x_E results

for n = 1:num_trials
    last_CS1_time = all_CS1_times.('x_E')(n, end); % get the last CS1 presentation
    last_CS2_time = all_CS2_times.('x_E')(n, end); % get the last CS2 presentation

    CS1_val(n) = nanmean(mean_phi_E.('x_E')(n, last_CS1_time:last_CS1_time+CS1_L/dt));
    CS2_val(n) = nanmean(mean_phi_E.('x_E')(n, last_CS2_time:last_CS2_time+CS2_L/dt));
end

% plot data
bar([4], [nanmean(CS1_val - CS2_val)], 'FaceColor', [0, 0, 0]);
hold on;
if nanmean(CS1_val - CS2_val) > 0
    errorbar([4], [nanmean(CS1_val - CS2_val)], [0], [nanstd(CS1_val - CS2_val)], 'k');
else
    errorbar([4], [nanmean(CS1_val - CS2_val)], [nanstd(CS1_val - CS2_val)], [0], 'k');
end
hold on;

% x_E_inhib results

for n = 1:num_trials
    last_CS1_time = all_CS1_times.('x_E_inhib')(n, end); % get the last CS1 presentation
    last_CS2_time = all_CS2_times.('x_E_inhib')(n, end); % get the last CS2 presentation

    CS1_val(n) = nanmean(mean_phi_E.('x_E_inhib')(n, last_CS1_time:last_CS1_time+CS1_L/dt));
    CS2_val(n) = nanmean(mean_phi_E.('x_E_inhib')(n, last_CS2_time:last_CS2_time+CS2_L/dt));
end

% plot data
bar([5], [nanmean(CS1_val - CS2_val)], 'FaceColor', [0.6, 0.6, 0.6]);
hold on;
if nanmean(CS1_val - CS2_val) > 0
    errorbar([5], [nanmean(CS1_val - CS2_val)], [0], [nanstd(CS1_val - CS2_val)], 'k');
else
    errorbar([5], [nanmean(CS1_val - CS2_val)], [nanstd(CS1_val - CS2_val)], [0], 'k');
end
hold on;

% I_E results

for n = 1:num_trials
    last_CS1_time = all_CS1_times.('I_E')(n, end); % get the last CS1 presentation
    last_CS2_time = all_CS2_times.('I_E')(n, end); % get the last CS2 presentation

    CS1_val(n) = nanmean(mean_phi_E.('I_E')(n, last_CS1_time:last_CS1_time+CS1_L/dt));
    CS2_val(n) = nanmean(mean_phi_E.('I_E')(n, last_CS2_time:last_CS2_time+CS2_L/dt));
end

% plot data
bar([7], [nanmean(CS1_val - CS2_val)], 'FaceColor', [0, 0, 0]);
hold on;
if nanmean(CS1_val - CS2_val) > 0
    errorbar([7], [nanmean(CS1_val - CS2_val)], [0], [nanstd(CS1_val - CS2_val)], 'k');
else
    errorbar([7], [nanmean(CS1_val - CS2_val)], [nanstd(CS1_val - CS2_val)], [0], 'k');
end
hold on;

% I_E_inhib results

for n = 1:num_trials
    last_CS1_time = all_CS1_times.('I_E_inhib')(n, end); % get the last CS1 presentation
    last_CS2_time = all_CS2_times.('I_E_inhib')(n, end); % get the last CS2 presentation

    CS1_val(n) = nanmean(mean_phi_E.('I_E_inhib')(n, last_CS1_time:last_CS1_time+CS1_L/dt));
    CS2_val(n) = nanmean(mean_phi_E.('I_E_inhib')(n, last_CS2_time:last_CS2_time+CS2_L/dt));
end

% plot data
bar([8], [nanmean(CS1_val - CS2_val)], 'FaceColor', [0.6, 0.6, 0.6]);
hold on;
if nanmean(CS1_val - CS2_val) > 0
    errorbar([8], [nanmean(CS1_val - CS2_val)], [0], [nanstd(CS1_val - CS2_val)], 'k');
else
    errorbar([8], [nanmean(CS1_val - CS2_val)], [nanstd(CS1_val - CS2_val)], [0], 'k');
end
hold on;

% save figure
print('figure_3D', '-dpng');
print('figure_3D', '-dsvg');