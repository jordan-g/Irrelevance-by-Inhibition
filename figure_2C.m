%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% figure_2C.m
%
% This is the script to create Figure 2C in Insel, Guerguiev and Richards (2018).
% Parameters controlling the simulations are given in the start of the main_script.m
% file, which also runs the simulations.

y_max_I = 25;
y_max_E = 5;

exp_name = ('x_I');

figure;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ---- Excitatory responses -----------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n_CS1_presentations = size(all_CS1_times.(exp_name), 2); % number of CS1 presentations
n_CS2_presentations = size(all_CS2_times.(exp_name), 2); % number of CS2 presentations

n_presentations = min(n_CS1_presentations, n_CS2_presentations); % get the minimum of the two

CS1_excitatory_responses     = [];
CS2_excitatory_responses     = [];
no_stim_excitatory_responses = [];

% get mean excitatory response to CS1 presentations, CS2 presentations, and between CS1 and CS2 presentations
for i = 1:n_presentations
    CS1_excitatory_responses(i)     = mean(mean_phi_E.(exp_name)(1, all_CS1_times.(exp_name)(1, i):all_CS1_times.(exp_name)(1, i) + CS1_L/dt));
    CS2_excitatory_responses(i)     = mean(mean_phi_E.(exp_name)(1, all_CS2_times.(exp_name)(1, i):all_CS2_times.(exp_name)(1, i) + CS2_L/dt));
    no_stim_excitatory_responses(i) = mean(mean_phi_E.(exp_name)(1, all_CS1_times.(exp_name)(1, i) + CS1_L/dt:all_CS1_times.(exp_name)(1, i) + 2*CS1_L/dt));
end

% generate a range of values spanning the presentations
x = linspace(1, n_presentations, n_presentations);

% plot data
subplot(1, 2, 1);
plot(x, no_stim_excitatory_responses, 'Color', [0, 0, 0]);
hold on;
plot(x, CS2_excitatory_responses, 'Color', [1.0, 0.5, 0]);
hold on;
plot(x, CS1_excitatory_responses, 'Color', [0, 0.8, 0]);

% set plot properties
axis([0, n_presentations, 0, y_max_E]);
title('Excitatory responses');
xlabel('Presentation number');
ylabel('E(t) mean firing rates (Hz)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ---- Inhibitory responses -----------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

CS1_inhibitory_responses     = [];
CS2_inhibitory_responses     = [];
no_stim_inhibitory_responses = [];

% get mean inhibitory response to CS1 presentations, CS2 presentations, and between CS1 and CS2 presentations
for i = 1:n_presentations
    CS1_inhibitory_responses(i)     = mean(mean_I.(exp_name)(1, all_CS1_times.(exp_name)(1, i):all_CS1_times.(exp_name)(1, i) + CS1_L/dt));
    CS2_inhibitory_responses(i)     = mean(mean_I.(exp_name)(1, all_CS2_times.(exp_name)(1, i):all_CS2_times.(exp_name)(1, i) + CS2_L/dt));
    no_stim_inhibitory_responses(i) = mean(mean_I.(exp_name)(1, all_CS1_times.(exp_name)(1, i) + CS1_L/dt:all_CS1_times.(exp_name)(1, i) + 2*CS1_L/dt));
end

% generate a range of values spanning the presentations
x = linspace(1, n_presentations, n_presentations);

% plot data
subplot(1, 2, 2);
plot(x, no_stim_inhibitory_responses, 'Color', [0, 0, 0]);
hold on;
plot(x, CS2_inhibitory_responses, 'Color', [1.0, 0.5, 0]);
hold on;
plot(x, CS1_inhibitory_responses, 'Color', [0, 0.8, 0]);

% set plot properties
axis([0, n_presentations, 0, y_max_I]);
title('Inhibitory responses');
ylabel('I(t) mean firing rates (Hz)');

% save figure
print('figure_2C', '-dpng');
print('figure_2C', '-dsvg');
