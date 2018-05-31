%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% fear_expression.m
%
% This is the script to perform the fear expression paradigm simulations described 
% in Insel, Guerguiev and Richards (2018). Parameters controlling the simulations 
% are given in the start of the main_script.m file, which also runs the simulations.

exp_names = {'inhibition', 'excitation'};

num_trials = 30;

for i = 1:length(exp_names)
    exp_name = char(exp_names(i));

    % flag for what the output units should be
    % 1: amygdala outputs
    output_flag = 1;

    % flag for which weights to update
    % 0: update x -> I weights
    learning_flag = 0;

    % flag for which training paradigm to use
    % 3: fear expression
    paradigm_flag = 3;

    % flag for whether to use bias terms
    use_bias = 0;

    % create hyperparameters
    hyperparameters;

    % update hyperparameters and set pre-training time
    T_pre   = 60;
    alpha_r = 0.01;
    alpha_y = 0.0075;
    CS1_L   = 6;
    CS2_L   = 6;
    US_L    = 6;

    if strcmp(exp_name, 'excitation')
        excitation = true;
    else
        excitation = false;
    end

    % create recording arrays
    mean_I.(exp_name)                    = [];
    mean_phi_E.(exp_name)                = [];
    norm_phi_E.(exp_name)                = [];
    mean_E.(exp_name)                    = [];
    norm_E.(exp_name)                    = [];
    max_y.(exp_name)                     = [];
    mean_y.(exp_name)                    = [];
    mean_phi_y.(exp_name)                = [];
    all_US_times.(exp_name)              = [];
    all_CS1_times.(exp_name)             = [];
    all_CS2_times.(exp_name)             = [];
    all_activation_stim_times.(exp_name) = [];
    all_inhibition_stim_times.(exp_name) = [];

    for n = 1:num_trials
        fprintf('exp_name = ''%s''. Trial %d/%d. learning_flag = %d, alpha_r = %f.\n', exp_name, n, num_trials, learning_flag, alpha_r);

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
        mean_y.(exp_name)(n, 1:nsteps)                   = mean(y);
        mean_phi_y.(exp_name)(n, 1:nsteps)               = mean(phi_y, 1);
        all_US_times.(exp_name)(n, 1:length(US_times))   = US_times;
        all_CS1_times.(exp_name)(n, 1:length(CS1_times)) = CS1_times;
        all_CS2_times.(exp_name)(n, 1:length(CS2_times)) = CS2_times;
        if excitation
            all_activation_stim_times.(exp_name)(n, 1:length(activation_stim_times)) = activation_stim_times;
        else
            all_inhibition_stim_times.(exp_name)(n, 1:length(inhibition_stim_times)) = inhibition_stim_times;
        end
    end
end

% create figures
