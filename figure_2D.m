%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% figure_2D.m
%
% This is the script to create Figure 2D in Insel, Guerguiev and Richards (2018).
% Parameters controlling the simulations are given in the start of the main_script.m
% file, which also runs the simulations.

y_max = 1.4;
y_min = 0;

exp_name = ('x_I');

figure;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ---- Weight update rule comparisons -------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ---- W_x2I --------------------------------------------------------------------%

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

bar([1], [nanmean(CS1_val - CS2_val)], 'FaceColor', [0, 0, 0]);
hold on;
errorbar([1], [nanmean(CS1_val - CS2_val)], [0], [nanstd(CS1_val - CS2_val)], 'k');
axis([0, 9, y_min, y_max]);
hold on;

% ---- W_x2I -10% inhibition ----------------------------------------------------%

for n = 1:num_trials
    last_CS1_time = all_CS1_times.('x_I_inhib')(n, end); % get the last CS1 presentation
    last_CS2_time = all_CS2_times.('x_I_inhib')(n, end); % get the last CS2 presentation

    CS1_val(n) = nanmean(mean_phi_E.('x_I_inhib')(n, last_CS1_time:last_CS1_time+CS1_L/dt));
    CS2_val(n) = nanmean(mean_phi_E.('x_I_inhib')(n, last_CS2_time:last_CS2_time+CS2_L/dt));
end

bar([2], [nanmean(CS1_val - CS2_val)], 'FaceColor', [0.6, 0.6, 0.6]);
hold on;
errorbar([2], [nanmean(CS1_val - CS2_val)], [0], [nanstd(CS1_val - CS2_val)], 'k');
hold on;

% ---- W_x2E --------------------------------------------------------------------%

for n = 1:num_trials
    last_CS1_time = all_CS1_times.('x_E')(n, end); % get the last CS1 presentation
    last_CS2_time = all_CS2_times.('x_E')(n, end); % get the last CS2 presentation

    CS1_val(n) = nanmean(mean_phi_E.('x_E')(n, last_CS1_time:last_CS1_time+CS1_L/dt));
    CS2_val(n) = nanmean(mean_phi_E.('x_E')(n, last_CS2_time:last_CS2_time+CS2_L/dt));
end

bar([4], [nanmean(CS1_val - CS2_val)], 'FaceColor', [0, 0, 0]);
hold on;
errorbar([4], [nanmean(CS1_val - CS2_val)], [0], [nanstd(CS1_val - CS2_val)], 'k');
hold on;

% ---- W_x2E -10% inhibition ----------------------------------------------------%

for n = 1:num_trials
    last_CS1_time = all_CS1_times.('x_E_inhib')(n, end); % get the last CS1 presentation
    last_CS2_time = all_CS2_times.('x_E_inhib')(n, end); % get the last CS2 presentation

    CS1_val(n) = nanmean(mean_phi_E.('x_E_inhib')(n, last_CS1_time:last_CS1_time+CS1_L/dt));
    CS2_val(n) = nanmean(mean_phi_E.('x_E_inhib')(n, last_CS2_time:last_CS2_time+CS2_L/dt));
end

bar([5], [nanmean(CS1_val - CS2_val)], 'FaceColor', [0.6, 0.6, 0.6]);
hold on;
errorbar([5], [nanmean(CS1_val - CS2_val)], [0], [nanstd(CS1_val - CS2_val)], 'k');
hold on;

% ---- W_I2E --------------------------------------------------------------------%

for n = 1:num_trials
    last_CS1_time = all_CS1_times.('I_E')(n, end); % get the last CS1 presentation
    last_CS2_time = all_CS2_times.('I_E')(n, end); % get the last CS2 presentation

    CS1_val(n) = nanmean(mean_phi_E.('I_E')(n, last_CS1_time:last_CS1_time+CS1_L/dt));
    CS2_val(n) = nanmean(mean_phi_E.('I_E')(n, last_CS2_time:last_CS2_time+CS2_L/dt));
end

bar([7], [nanmean(CS1_val - CS2_val)], 'FaceColor', [0, 0, 0]);
hold on;
errorbar([7], [nanmean(CS1_val - CS2_val)], [0], [nanstd(CS1_val - CS2_val)], 'k');
hold on;

% ---- W_I2E -10% inhibition ----------------------------------------------------%

for n = 1:num_trials
    last_CS1_time = all_CS1_times.('I_E_inhib')(n, end); % get the last CS1 presentation
    last_CS2_time = all_CS2_times.('I_E_inhib')(n, end); % get the last CS2 presentation

    CS1_val(n) = nanmean(mean_phi_E.('I_E_inhib')(n, last_CS1_time:last_CS1_time+CS1_L/dt));
    CS2_val(n) = nanmean(mean_phi_E.('I_E_inhib')(n, last_CS2_time:last_CS2_time+CS2_L/dt));
end

bar([8], [nanmean(CS1_val - CS2_val)], 'FaceColor', [0.6, 0.6, 0.6]);
hold on;
errorbar([8], [nanmean(CS1_val - CS2_val)], [0], [nanstd(CS1_val - CS2_val)], 'k');
hold on;

% save figure
print('figure_2D', '-dpng');
print('figure_2D', '-dsvg');