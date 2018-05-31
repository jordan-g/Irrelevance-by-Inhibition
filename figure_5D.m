%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% figure_5D.m
%
% This is the script to create Figure 5D in Insel, Guerguiev and Richards (2018).
% Parameters controlling the simulations are given in the start of the main_script.m
% file, which also runs the simulations.

y_max = 3;

figure;

% figure out starting presentation # for non-pre-exposure conditions
n_CS1_presentations = size(all_CS1_times.('control'), 2); % number of CS1 presentations in non-preexposure conditions
n_CS1_presentations_preexposure = size(all_CS1_times.('control_preexposure'), 2); % number of CS1 presentations in preexposure conditions
offset = n_CS1_presentations_preexposure - n_CS1_presentations;

% generate a range of values spanning the presentations
x = linspace(1, n_CS1_presentations_preexposure, n_CS1_presentations_preexposure);

CS1_excitatory_responses = [];
CS1_excitatory_responses(1:offset) = nan;

% ---- Control ------------------------------------------------------------------%

% get mean excitatory response to CS1 presentations
for i = 1:n_CS1_presentations
    CS1_excitatory_responses(offset + i) = mean(max_y.('control')(1, all_CS1_times.('control')(1, i):all_CS1_times.('control')(1, i) + CS1_L/dt));
end

plot(x, CS1_excitatory_responses, 'Color', [0.5, 0.5, 0.5]);
hold on;

% ---- Conditioning -20% inhibition ---------------------------------------------%

% get mean excitatory response to CS1 presentations
for i = 1:n_CS1_presentations
    CS1_excitatory_responses(offset + i) = mean(max_y.('inhibition_conditioning')(1, all_CS1_times.('inhibition_conditioning')(1, i):all_CS1_times.('inhibition_conditioning')(1, i) + CS1_L/dt));
end

plot(x, CS1_excitatory_responses, 'Color', [1.0, 0.2, 0]);
hold on;

% ---- Test -20% inhibition -----------------------------------------------------%

% get mean excitatory response to CS1 presentations
for i = 1:n_CS1_presentations
    CS1_excitatory_responses(offset + i) = mean(max_y.('inhibition_test')(1, all_CS1_times.('inhibition_test')(1, i):all_CS1_times.('inhibition_test')(1, i) + CS1_L/dt));
end

plot(x, CS1_excitatory_responses, 'Color', [0.0, 0.2, 1.0]);
hold on;

% ---- Control pre-exposure -----------------------------------------------------%

% get mean excitatory response to CS1 presentations
for i = 1:n_CS1_presentations_preexposure
    CS1_excitatory_responses(i) = mean(max_y.('control_preexposure')(1, all_CS1_times.('control_preexposure')(1, i):all_CS1_times.('control_preexposure')(1, i) + CS1_L/dt));
end

plot(x, CS1_excitatory_responses, '--', 'Color', [0.5, 0.5, 0.5]);
hold on;

% ---- Conditioning -20% inhibition pre-exposure --------------------------------%

% get mean excitatory response to CS1 presentations
for i = 1:n_CS1_presentations_preexposure
    CS1_excitatory_responses(i) = mean(max_y.('inhibition_conditioning_preexposure')(1, all_CS1_times.('inhibition_conditioning_preexposure')(1, i):all_CS1_times.('inhibition_conditioning_preexposure')(1, i) + CS1_L/dt));
end

plot(x, CS1_excitatory_responses, '--', 'Color', [1.0, 0.2, 0]);
hold on;

% ---- Test -20% inhibition pre-exposure ----------------------------------------%

% get mean excitatory response to CS1 presentations
for i = 1:n_CS1_presentations_preexposure
    CS1_excitatory_responses(i) = mean(max_y.('inhibition_test_preexposure')(1, all_CS1_times.('inhibition_test_preexposure')(1, i):all_CS1_times.('inhibition_test_preexposure')(1, i) + CS1_L/dt));
end

plot(x, CS1_excitatory_responses, '--', 'Color', [0.0, 0.2, 1.0]);
hold on;

% set plot properties
axis([offset+1, n_CS1_presentations_preexposure, 0, y_max]);
title('Latent inhibition');
xlabel('Presentation number');
ylabel('y(t) mean activity');

% save figure
print('figure_5D', '-dpng');
print('figure_5D', '-dsvg');