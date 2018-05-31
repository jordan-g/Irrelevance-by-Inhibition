%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% learned_irrelevance_cross_correlation.m
%
% This is the script to create a cross-correlation figure for the learned
% irrelevance paradigm with the model described in Insel, Guerguiev and Richards (2018).

num_trials = 100;

% flag for which training paradigm to use
% 0: learned irrelevance
paradigm_flag = 0;

% create hyperparameters
hyperparameters;

% create recording arrays
all_US_t  = [];
all_CS1_t = [];
all_CS2_t = [];

for n = 1:num_trials
    fprintf('Trial %d/%d.\n', n, num_trials);

    % create stimulus sequences
    stimuli;

    % update recording arrays
    all_US_t(n, :)  = US_t;
    all_CS1_t(n, :) = CS1_t;
    all_CS2_t(n, :) = CS2_t;
end

y_min = 2;
y_max = 4;

for n = 1:num_trials
    US_CS1_cross_correlation = xcorr(all_US_t(n, :), all_CS1_t(n, :));
    US_CS2_cross_correlation = xcorr(all_US_t(n, :), all_CS2_t(n, :));
    if n == 1
        mean_US_CS1_cross_correlation = zeros(size(US_CS1_cross_correlation));
        mean_US_CS2_cross_correlation = zeros(size(US_CS2_cross_correlation));
    end
    mean_US_CS1_cross_correlation = mean_US_CS1_cross_correlation + US_CS1_cross_correlation;
    mean_US_CS2_cross_correlation = mean_US_CS2_cross_correlation + US_CS2_cross_correlation;
end
mean_US_CS1_cross_correlation = mean_US_CS1_cross_correlation/num_trials;
mean_US_CS2_cross_correlation = mean_US_CS2_cross_correlation/num_trials;

% plot data
figure;
plot(mean_US_CS1_cross_correlation, 'Color', [0, 0.5, 1.0]);
hold on;
plot(mean_US_CS2_cross_correlation, 'Color', [1.0, 0.5, 0]);

% set plot properties
title('Cross-correlation between stimuli');
xlabel('Lag (timestep)');
ylabel('Cross-correlation');
legend('US-CS1 cross-correlation', 'US-CS2 cross-correlation')

% save figure
print('figure_learned_irrelevance_cross_correlation', '-dpng');
print('figure_learned_irrelevance_cross_correlation', '-dsvg');
