%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% learned_irrelevance.m
%
% This is the script to plot the learned irrelevance results for the model described 
% in Insel, Guerguiev and Richards (2018). Parameters controlling the simulations 
% are given in the learned_irrelevance.m file, which also runs the simulations.

% exp_names = {'normal', 'normal_preexposure'};
exp_names = {'normal_preexposure'};

num_trials = 10;

for i = 1:length(exp_names)
    exp_name = char(exp_names(i));

    % flag for what the output units should be
    % 1: amygdala outputs
    output_flag = 1;

    % flag for which weights to update
    % 0: update x -> I weights
    learning_flag = 0;

    % flag for which training paradigm to use
    % 5: learned irrelevance
    paradigm_flag = 5;

    % create hyperparameters
    hyperparameters;

    % update hyperparameters and set pre-training times
    T_pre   = 60;
    alpha_r = 0.075;
    alpha_y = 0.0075;

    % flag for whether to use bias terms
    use_bias = 0;

    % set pre-exposure flag
    if endsWith(exp_name, '_preexposure')
        preexposure = true;
    else
        preexposure = false;
    end

    % create recording arrays
    mean_I.(exp_name)        = [];
    mean_phi_E.(exp_name)    = [];
    norm_phi_E.(exp_name)    = [];
    mean_E.(exp_name)        = [];
    norm_E.(exp_name)        = [];
    all_US_times.(exp_name)  = [];
    all_CS1_times.(exp_name) = [];

    for n = 1:num_trials
        fprintf('exp_name = ''%s''. Trial %d/%d. learning_flag = %d, I_scale = %.2f. alpha_r = %f.\n', exp_name, n, num_trials, learning_flag, I_scale, alpha_r);

        % create stimulus sequences
        stimuli;

        % initialize dynamic variables
        init;

        % train the network
        train;

        % update recording arrays
        nsteps  = ceil(T/dt);
        mean_I.(exp_name)(n, 1:nsteps)                   = mean(I, 1);
        mean_phi_E.(exp_name)(n, 1:nsteps)               = mean(phi_E, 1);
        norm_phi_E.(exp_name)(n, 1:nsteps)               = sqrt(sum(phi_E.^2, 1));
        mean_E.(exp_name)(n, 1:nsteps)                   = mean(E, 1);
        norm_E.(exp_name)(n, 1:nsteps)                   = sqrt(sum(E.^2, 1));
        max_y.(exp_name)(n, 1:nsteps)                    = max(y);
        all_US_times.(exp_name)(n, 1:length(US_times))   = US_times;
        all_CS1_times.(exp_name)(n, 1:length(CS1_times)) = CS1_times;
    end
end

% create figure
figure_learned_irrelevance;
