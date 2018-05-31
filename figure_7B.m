%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% figure_7B.m
%
% This is the script to create Figure 7B in Insel, Guerguiev and Richards (2018).
% Parameters controlling the simulations are given in the start of the main_script.m
% file, which also runs the simulations.

y_max = 3;

figure;

n_CS1_presentations = size(all_CS1_times, 2); % number of CS1 presentations
n_CS2_presentations = size(all_CS2_times, 2); % number of CS2 presentations

n_presentations = min(n_CS1_presentations, n_CS2_presentations); % get the minimum of the two

CS1_S     = [];
CS2_S     = [];
no_stim_S = [];

% get mean excitatory responses to CS presentations, separated by stimuli
for i = 1:n_presentations
    CS1_S(i)  = mean(mean_S(1, all_CS1_times(1, i):all_CS1_times(1, i) + CS1_L/dt));
    CS2_S(i)  = mean(mean_S(1, all_CS2_times(1, i):all_CS2_times(1, i) + CS1_L/dt));
    CS3_S(i)  = mean(mean_S(1, all_CS3_times(1, i):all_CS3_times(1, i) + CS1_L/dt));
    CS4_S(i)  = mean(mean_S(1, all_CS4_times(1, i):all_CS4_times(1, i) + CS1_L/dt));
    CS5_S(i)  = mean(mean_S(1, all_CS5_times(1, i):all_CS5_times(1, i) + CS1_L/dt));
    CS6_S(i)  = mean(mean_S(1, all_CS6_times(1, i):all_CS6_times(1, i) + CS1_L/dt));
    CS7_S(i)  = mean(mean_S(1, all_CS7_times(1, i):all_CS7_times(1, i) + CS1_L/dt));
    CS8_S(i)  = mean(mean_S(1, all_CS8_times(1, i):all_CS8_times(1, i) + CS1_L/dt));
    CS9_S(i)  = mean(mean_S(1, all_CS9_times(1, i):all_CS9_times(1, i) + CS1_L/dt));
    CS10_S(i) = mean(mean_S(1, all_CS10_times(1, i):all_CS10_times(1, i) + CS1_L/dt));
end

% generate a range of values spanning the presentations
x = linspace(1, n_presentations, n_presentations);

% make lists of rewarded & unrewarded stimuli
stimuli_list = vertcat(CS1_S, CS2_S, CS3_S, CS4_S, CS5_S, CS6_S, CS7_S, CS8_S, CS9_S, CS10_S);
unrewarded_stimuli = stimuli_list(num_rewarded+1:end, :);
rewarded_stimuli   = stimuli_list(1:num_rewarded, :);

% plot unrewarded stimuli data
X = [x, fliplr(x)];
Y = [max(unrewarded_stimuli, [], 1), fliplr(min(unrewarded_stimuli, [], 1))];
h = fill(X, Y, [1.0, 0.5, 0]);
set(h, 'facealpha', .2);
set(h, 'EdgeColor', 'none');
hold on;
plot(x, mean(unrewarded_stimuli, 1), 'Color', [1.0, 0.5, 0]);
hold on;

% plot unrewarded stimuli data
X = [x, fliplr(x)];
Y = [max(rewarded_stimuli, [], 1), fliplr(min(rewarded_stimuli, [], 1))];
h = fill(X, Y, [0, 0.8, 0]);
set(h, 'facealpha', .2);
set(h, 'EdgeColor', 'none');
plot(x, mean(rewarded_stimuli, 1), 'Color', [0, 0.8, 0]);

% set plot properties
axis([0, n_presentations, 0, y_max]);
title('S(t)');
xlabel('Presentation number');
ylabel('mean S(t)');

% save figure
print('figure_7B', '-dpng');
print('figure_7B', '-dsvg');