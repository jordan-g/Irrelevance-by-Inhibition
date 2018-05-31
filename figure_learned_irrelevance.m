%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% figure_learned_irrelevance.m
%
% This is the script to create a learned irrelevancy figure for the model in Insel,
% Guerguiev and Richards (2018). Parameters controlling the simulations are given
% in the start of the main_script.m file, which also runs the simulations.

y_min = 0;
y_max = 3;

figure;

% ---- Pre-exposure -------------------------------------------------------------%

n_CS1_presentations_preexposure = size(all_CS1_times.('normal_preexposure'), 2); % number of CS1 presentations

mean_CS1_excitatory_responses_preexposure = [];
min_CS1_excitatory_responses_preexposure  = [];
max_CS1_excitatory_responses_preexposure  = [];

% get mean, min and max excitatory response to CS1 presentations, CS2 presentations, and between CS1 and CS2 presentations
for i = 1:n_CS1_presentations_preexposure
    mean_CS1_excitatory_responses_preexposure(i) = mean(mean(norm_E.('normal_preexposure')(:, all_CS1_times.('normal_preexposure')(:, i):all_CS1_times.('normal_preexposure')(:, i) + CS1_L/dt) - H, 2));
    min_CS1_excitatory_responses_preexposure(i)  = mean_CS1_excitatory_responses_preexposure(i) - std(mean(norm_E.('normal_preexposure')(:, all_CS1_times.('normal_preexposure')(:, i):all_CS1_times.('normal_preexposure')(:, i) + CS1_L/dt) - H, 2));
    max_CS1_excitatory_responses_preexposure(i)  = mean_CS1_excitatory_responses_preexposure(i) + std(mean(norm_E.('normal_preexposure')(:, all_CS1_times.('normal_preexposure')(:, i):all_CS1_times.('normal_preexposure')(:, i) + CS1_L/dt) - H, 2));
end

% generate x range
x_preexposure = linspace(1, n_CS1_presentations_preexposure, n_CS1_presentations_preexposure);

% plot data
plot(x_preexposure, mean_CS1_excitatory_responses_preexposure, 'Color', [0, 0.8, 0]);
hold on;
X = [x_preexposure, fliplr(x_preexposure)];
Y = [max_CS1_excitatory_responses_preexposure, fliplr(min_CS1_excitatory_responses_preexposure)];
h = fill(X, Y, [0, 0.8, 0]);
set(h, 'facealpha', .2);
set(h, 'EdgeColor', 'none');
hold on;

% ---- Non-pre-exposure ---------------------------------------------------------%

n_CS1_presentations = size(all_CS1_times.('normal'), 2); % number of CS1 presentations

mean_CS1_excitatory_responses = [];
min_CS1_excitatory_responses  = [];
max_CS1_excitatory_responses  = [];

% get mean, min and max excitatory response to CS1 presentations, CS2 presentations, and between CS1 and CS2 presentations
for i = 1:n_CS1_presentations
    mean_CS1_excitatory_responses(i) = mean(mean(norm_E.('normal')(:, all_CS1_times.('normal')(1, i):all_CS1_times.('normal')(1, i) + CS1_L/dt) - H, 2));
    min_CS1_excitatory_responses(i)  = mean_CS1_excitatory_responses(i) - std(mean(norm_E.('normal')(:, all_CS1_times.('normal')(1, i):all_CS1_times.('normal')(1, i) + CS1_L/dt) - H, 2));
    max_CS1_excitatory_responses(i)  = mean_CS1_excitatory_responses(i) + std(mean(norm_E.('normal')(:, all_CS1_times.('normal')(1, i):all_CS1_times.('normal')(1, i) + CS1_L/dt) - H, 2));
end

% generate x range
x = linspace(n_CS1_presentations_preexposure - n_CS1_presentations, n_CS1_presentations_preexposure, n_CS1_presentations);

% plot data
plot(x, mean_CS1_excitatory_responses, 'Color', [0, 0, 0.8]);
hold on;
X = [x, fliplr(x)];
Y = [max_CS1_excitatory_responses, fliplr(min_CS1_excitatory_responses)];
h = fill(X, Y, [0, 0, 0.8]);
set(h, 'facealpha', .2);
set(h, 'EdgeColor', 'none');
hold on;

% set plot properties
axis([0, n_CS1_presentations_preexposure, y_min, y_max]);
title('Excitatory responses');
xlabel('Presentation number');
ylabel('S(t)');

% save figure
print('figure_learned_irrelevance', '-dpng');
print('figure_learned_irrelevance', '-dsvg');
