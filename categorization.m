%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% categorization.m
%
% This is the script to perform the categorization paradigm simulations described 
% in Insel, Guerguiev and Richards (2018). Parameters controlling the simulations 
% are given in the start of the main_script.m file, which also runs the simulations.

num_trials = 10;

% flag for what the output units should be
% 2: softmax outputs
output_flag = 2;

% flag for which weights to update
% 0: update x -> I weights
learning_flag = 0;

% flag for which training paradigm to use
% 4: categorization
paradigm_flag = 4;

% flag for whether to use bias terms
use_bias = 0;

% create hyperparameters
hyperparameters;

% update hyperparameters and set pre-training times
T_pre   = 60;
alpha_r = 0.075;
alpha_y = 0.00001;

% set number of stimuli that are associated with a US
num_rewarded = 1;

% create recording arrays
mean_I         = [];
mean_phi_E     = [];
norm_phi_E     = [];
mean_E         = [];
norm_E         = [];
mean_S         = [];
cross_entropy  = [];
all_test_acc   = [];
all_US_times   = [];
all_CS1_times  = [];
all_CS2_times  = [];
all_CS3_times  = [];
all_CS4_times  = [];
all_CS5_times  = [];
all_CS6_times  = [];
all_CS7_times  = [];
all_CS8_times  = [];
all_CS9_times  = [];
all_CS10_times = [];

for n = 1:num_trials
    fprintf('Trial %d/%d. learning_flag = %d, I_scale = %.2f, alpha_r = %f, alpha_y = %f.\n', n, num_trials, learning_flag, I_scale, alpha_r, alpha_y);

    % create stimulus sequences
    stimuli;

    % initialize dynamic variables
    init;

    % train the network
    train;

    % update recording arrays
    nsteps  = ceil(T/dt);
    mean_I(n, 1:nsteps)                     = mean(I, 1);
    mean_phi_E(n, 1:nsteps)                 = mean(phi_E, 1);
    norm_phi_E(n, 1:nsteps)                 = sqrt(sum(phi_E.^2, 1));
    mean_E(n, 1:nsteps)                     = mean(E, 1);
    norm_E(n, 1:nsteps)                     = sqrt(sum(E.^2, 1));
    mean_S(n, 1:nsteps)                     = mean(S, 1);
    cross_entropy(n, 1:nsteps)              = L;
    all_US_times(n, 1:length(US_times))     = US_times;
    all_CS1_times(n, 1:length(CS1_times))   = CS1_times;
    all_CS2_times(n, 1:length(CS2_times))   = CS2_times;
    all_CS3_times(n, 1:length(CS3_times))   = CS3_times;
    all_CS4_times(n, 1:length(CS4_times))   = CS4_times;
    all_CS5_times(n, 1:length(CS5_times))   = CS5_times;
    all_CS6_times(n, 1:length(CS6_times))   = CS6_times;
    all_CS7_times(n, 1:length(CS7_times))   = CS7_times;
    all_CS8_times(n, 1:length(CS8_times))   = CS8_times;
    all_CS9_times(n, 1:length(CS9_times))   = CS9_times;
    all_CS10_times(n, 1:length(CS10_times)) = CS10_times;
    all_test_acc(n, 1:length(test_acc))     = test_acc;
end

% create figures
figure_7B;
figure_7C;