%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% blocking.m
%
% This is the script to perform the blocking paradigm simulations described 
% in Insel, Guerguiev and Richards (2018). Parameters controlling the simulations 
% are given in the start of the main_script.m file, which also runs the simulations.

exp_names = {'x_I', 'x_I_inhib', 'x_E', 'x_E_inhib', 'I_E', 'I_E_inhib'};

num_trials = 30;

for i = 1:length(exp_names)
    exp_name = char(exp_names(i));

    % flag for what the output units should be
    % 0: no output units
    output_flag = 0;

    % flag for which weights to update
    % 0: update x -> I weights
    % 1: update x -> E weights
    % 2: update I -> E weights
    if startsWith(exp_name, 'x_I')
        learning_flag = 0;
    elseif startsWith(exp_name, 'x_E')
        learning_flag = 1;
    else
        learning_flag = 2;
    end

    % flag for which training paradigm to use
    % 1: blocking
    paradigm_flag = 1;

    % flag for whether to use bias terms
    use_bias = 0;

    % create hyperparameters
    hyperparameters;

    % update hyperparameters and set pre-training times
    T_pre = 60;
    if learning_flag == 0
        alpha_r = 0.075;
    elseif learning_flag == 1
        alpha_r = 0.001;
    else
        alpha_r = 0.001;
    end

    % create recording arrays
    mean_I.(exp_name)        = [];
    mean_phi_E.(exp_name)    = [];
    norm_phi_E.(exp_name)    = [];
    mean_E.(exp_name)        = [];
    norm_E.(exp_name)        = [];
    all_US_times.(exp_name)  = [];
    all_CS1_times.(exp_name) = [];
    all_CS2_times.(exp_name) = [];

    for n = 1:num_trials
        fprintf('exp_name = ''%s''. Trial %d/%d. learning_flag = %d, I_scale = %.2f. alpha_r = %f.\n', exp_name, n, num_trials, learning_flag, I_scale, alpha_r);

        % set the scale of inhibition on excitatory units
        if endsWith(exp_name, '_inhib')
            I_scale = 0.9;
        else
            I_scale = 1;
        end

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
        all_US_times.(exp_name)(n, 1:length(US_times))   = US_times;
        all_CS1_times.(exp_name)(n, 1:length(CS1_times)) = CS1_times;
        all_CS2_times.(exp_name)(n, 1:length(CS2_times)) = CS2_times;
    end
end

% create figures
figure_3B;
figure_3C;
figure_3D;