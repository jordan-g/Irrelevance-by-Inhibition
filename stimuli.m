%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% stimuli.m
%
% This is the script to create stimulus sequences for the simulations described 
% in Insel, Guerguiev and Richards (2018). Parameters controlling the simulations 
% are given in the start of the main_script.m file, which also runs the simulations.

% CS1 and CS2 active units
num_active = ceil(num_x/10);              % number of units that are active during CS presentations
CS1_units  = [1:num_active];              % arbitrary units that are active during CS1 presentation
CS2_units  = [num_active+1:2*num_active]; % arbitrary units that are active during CS2 presentation

% set pre-training time
T_pre = 60;

if paradigm_flag == 0 % learning to ignore
    T = 2000; % length of training (s)

    % minimum and maximum interval lengths between US presentations (s)
    min_D_US = 20;
    max_D_US = 30;

    % determine time steps when the US is shown using intervals
    % drawn from a uniform distribution
    US_t     = zeros(ceil(T/dt), 1); % vector showing when US is shown (1 if US is present, 0 if not)
    US_times = [];             % start times of US presentations (timesteps)
    t = 0;
    while t < T
        D_US = random('Uniform', min_D_US, max_D_US);
        t = t + D_US;
        if t <= T - US_L
            US_time = floor(t/dt);
            US_times = [US_times; US_time];
            US_t(US_time:US_time+US_L/dt) = 1;
        end
    end
    
    % determine time steps when CS1 is shown, either
    % deterministically or randomly from a uniform distribution
    CS1_t = zeros(ceil(T/dt), 1);
    if CS1_r == 1
        CS1_times = US_times - round(US_D/dt);
    else
        CS1_times = sort(round(random('Uniform', 1, (T - CS1_L)/dt, length(US_times), 1)));
    end

    for i = 1:length(CS1_times)
        CS1_start = CS1_times(i);
        CS1_t(CS1_start:CS1_start+CS1_L/dt) = 1;
    end

    % determine time steps when CS2 is shown, either
    % deterministically or randomly from a uniform distribution
    CS2_t = zeros(ceil(T/dt), 1);
    if CS2_r == 1
        CS2_times = US_times - round(1/dt);
    else
        CS2_times = sort(round(random('Uniform', 1, (T - CS2_L)/dt, length(US_times), 1)));
    end

    for j = 1:length(CS2_times)
        CS2_start = CS2_times(j);
        CS2_t(CS2_start:CS2_start+CS2_L/dt) = 1;
    end
elseif paradigm_flag == 1 % blocking
    % initialize start times of US, CS1 and CS2 presentations (timesteps)
    US_times  = [];
    CS1_times = [];
    CS2_times = [];

    % pre-exposure - CS1 and CS2 shown one after the other, 50 presentations each
    
    % minimum and maximum interval lengths between stimulus presentations (s)
    min_D = 10;
    max_D = 15;

    t_1 = 0;
    t_2 = 0;
    num_presentations = 0;
    while num_presentations < 50
        % get the next presentation start times
        D_1 = random('Uniform', min_D, max_D);
        D_2 = random('Uniform', min_D, max_D);
        t_1 = t_1 + D_1;
        t_2 = t_2 + D_2;
        CS1_time = round(t_1/dt);
        CS2_time = round(t_2/dt);

        CS1_times = [CS1_times; CS1_time];
        CS2_times = [CS2_times; CS2_time];

        num_presentations = num_presentations + 1;

        t_1 = t_1 + CS1_L;
        t_2 = t_2 + CS2_L;
    end

    % conditioning - US and CS1 shown together, 50 times

    % minimum and maximum interval lengths between US presentations (s)
    min_D_US = 10;
    max_D_US = 15;

    t = max(t_1, t_2);

    num_presentations = 0;
    while num_presentations < 50
        D = random('Uniform', min_D_US, max_D_US);
        t = t + D;
        US_time = round(t/dt);
        US_times  = [US_times; US_time];
        CS1_times = [CS1_times; US_time - round(US_D/dt)];

        num_presentations = num_presentations + 1;

        t = t + US_L;
    end

    % blocking - US, CS1 and CS2 shown together, 50 times
    num_presentations = 0;
    while num_presentations < 50
        D = random('Uniform', min_D_US, max_D_US);
        t = t + D;
        US_time = round(t/dt);
        US_times  = [US_times; US_time];
        CS1_times = [CS1_times; US_time - round(US_D/dt)];
        CS2_times = [CS2_times; US_time - round(US_D/dt)];

        num_presentations = num_presentations + 1;

        t = t + US_L;
    end

    t_1 = t;
    t_2 = t;

    % testing - CS1 and CS2 shown one after the other, 10 presentations each
    num_presentations = 0;
    while num_presentations < 10
        D_1 = random('Uniform', min_D, max_D);
        D_2 = random('Uniform', min_D, max_D);
        t_1 = t_1 + D_1;
        t_2 = t_2 + D_2;
        CS1_time = round(t_1/dt);
        CS2_time = round(t_2/dt);

        CS1_times = [CS1_times; CS1_time];
        CS2_times = [CS2_times; CS2_time];

        num_presentations = num_presentations + 1;

        t_1 = t_1 + CS1_L;
        t_2 = t_2 + CS2_L;
    end

    % determine total # of timesteps
    T = ceil(max([US_times(end) + US_L/dt, CS1_times(end) + CS1_L/dt, CS2_times(end) + CS2_L/dt]))*dt;

    % generate US_t, CS1_t, CS2_t
    US_t  = zeros(ceil(T/dt), 1); % vector showing when US is shown (1 if US is present, 0 if not)
    CS1_t = zeros(ceil(T/dt), 1); % vector showing when CS1 is shown (1 if CS1 is present, 0 if not)
    CS2_t = zeros(ceil(T/dt), 1); % vector showing when CS2 is shown (1 if CS2 is present, 0 if not)

    for i = 1:length(US_times)
        US_start = US_times(i);
        US_t(US_start:US_start+US_L/dt) = 1;
    end
    for i = 1:length(CS1_times)
        CS1_start = CS1_times(i);
        CS1_t(CS1_start:CS1_start+CS1_L/dt) = 1;
    end
    for i = 1:length(CS2_times)
        CS2_start = CS2_times(i);
        CS2_t(CS2_start:CS2_start+CS2_L/dt) = 1;
    end
elseif paradigm_flag == 2 % latent inhibition
    % initialize start times of US, CS1 and CS2 presentations (timesteps)
    US_times  = [];
    CS1_times = [];
    CS2_times = [];
    
    % interval lengths between stimulus presentations (s)
    D = 4;

    t = 0;

    % pre-exposure - 30 presentations of CS1
    if preexposure
        num_presentations = 0;
        while num_presentations < 30
            % get the next presentation start time
            t = t + D;
            CS1_time = round(t/dt);

            CS1_times = [CS1_times; CS1_time];

            num_presentations = num_presentations + 1;

            t = t + CS1_L;
        end
    end

    % conditioning - US and CS1 shown together, 3 times
    conditioning_start_time = t;
    num_presentations = 0;
    while num_presentations < 3
        t = t + D;
        US_time = round(t/dt);
        US_times  = [US_times; US_time];
        CS1_times = [CS1_times; US_time];

        num_presentations = num_presentations + 1;

        t = t + CS1_L;
    end


    % testing - CS1 shown alone, 4 times
    test_start_time = t;
    num_presentations = 0;
    while num_presentations < 4
        t = t + D;
        CS1_time = round(t/dt);

        CS1_times = [CS1_times; CS1_time];

        num_presentations = num_presentations + 1;

        t = t + CS1_L;
    end

    % generate US_t, CS1_t, CS2_t
    T = ceil(max([US_times(end) + US_L/dt, CS1_times(end) + CS1_L/dt]))*dt;

    US_t  = zeros(ceil(T/dt), 1); % vector showing when US is shown (1 if US is present, 0 if not)
    CS1_t = zeros(ceil(T/dt), 1); % vector showing when CS1 is shown (1 if CS1 is present, 0 if not)
    CS2_t = zeros(ceil(T/dt), 1); % vector showing when CS2 is shown (1 if CS2 is present, 0 if not)

    for i = 1:length(US_times)
        US_start = US_times(i);
        US_t(US_start:US_start+US_L/dt) = 1;
    end
    for i = 1:length(CS1_times)
        CS1_start = CS1_times(i);
        CS1_t(CS1_start:CS1_start+CS1_L/dt) = 1;
    end
    for i = 1:length(CS2_times)
        CS2_start = CS2_times(i);
        CS2_t(CS2_start:CS2_start+CS2_L/dt) = 1;
    end

    nsteps  = ceil(T/dt);

    % create I_scale array
    I_scale_array = ones(nsteps, 1);
    if inhibition_conditioning
        I_scale_array(conditioning_start_time/dt +1:test_start_time/dt) = 0.8;
    elseif inhibition_test
        I_scale_array(test_start_time/dt + 1:end) = 0.8;
    end
elseif paradigm_flag == 3 % fear expression
    % initialize start times of US, CS1 and CS2 presentations (timesteps)
    US_times  = [];
    CS1_times = [];
    CS2_times = [];
    inhibition_stim_times = [];
    activation_stim_times = [];

    t = 0;

    % habituation phase

    % 8 presentations in total, 4 of CS1 and 4 of CS2
    % their order is randomly chosen
    CS_order = zeros(8, 1);
    CS_order(randperm(8, 4)) = 1;
    
    % interval lengths between stimulus presentations (s)
    min_D = 4;
    max_D = 36;

    num_presentations = 0;
    while num_presentations < 8
        % get the next presentation start time
        D = random('Uniform', min_D, max_D);
        t = t + D;

        if CS_order(num_presentations+1) == 1
            CS1_time = round(t/dt);
            CS1_times = [CS1_times; CS1_time];
            t = t + CS1_L;
        else
            CS2_time = round(t/dt);
            CS2_times = [CS2_times; CS2_time];
            t = t + CS2_L;
        end

        num_presentations = num_presentations + 1;
    end

    if ~excitation
        % pre-conditioning -20% inhibition phase

        num_stims = 108;  % 0.9Hz for 120 s
        stim_D    = 0.86; % 860 ms between stimulations
        stim_L    = 0.25; % each stimulation is 250 ms long

        num_stims = 0;
        while num_stims < 108
            % get the next presentation start time
            t = t + stim_D;
            inhibition_stim_time = round(t/dt);

            inhibition_stim_times = [inhibition_stim_times; inhibition_stim_time];

            num_stims = num_stims + 1;

            t = t + stim_L;
        end
    end

    % conditioning phase

    % 10 presentations in total, 5 of CS1 paired with US
    % and 5 of CS2, alternating
    CS_order = zeros(10, 1);
    CS_order([1 3 5 7 9]) = 1;

    num_presentations = 0;
    while num_presentations < 10
        % get the next presentation start time
        D = random('Uniform', min_D, max_D);
        t = t + D;

        if mod(num_presentations+1, 2) == 1
            CS1_time = round(t/dt);
            CS1_times = [CS1_times; CS1_time];
            US_times  = [US_times; CS1_time];
            t = t + CS1_L;
        else
            CS2_time = round(t/dt);
            CS2_times = [CS2_times; CS2_time];
            t = t + CS2_L;
        end

        num_presentations = num_presentations + 1;
    end

    if excitation
        % post-conditioning test phase

        % 4 presentations of CS1 alone, followed by
        % 4 presentations of CS1 with -20% inhibition

        num_presentations = 0;
        while num_presentations < 4
            % get the next presentation start time
            D = random('Uniform', min_D, max_D);
            t = t + D;

            CS1_time = round(t/dt);
            CS1_times = [CS1_times; CS1_time];
            t = t + CS1_L;

            num_presentations = num_presentations + 1;
        end

        num_presentations = 0;
        while num_presentations < 4
            % get the next presentation start time
            D = random('Uniform', min_D, max_D);
            t = t + D;

            CS1_time = round(t/dt);
            CS1_times = [CS1_times; CS1_time];

            activation_stim_time = round(t/dt);
            activation_stim_times = [activation_stim_times; activation_stim_time];

            t = t + CS1_L;

            num_presentations = num_presentations + 1;
        end
    else
        % extinction phase

        % 16 presentations in total, 12 of CS1 and 4 of CS2
        % their order is randomly chosen
        CS_order = ones(16, 1);
        CS_order(randperm(16, 4)) = 0;

        num_presentations = 0;
        while num_presentations < 16
            % get the next presentation start time
            D = random('Uniform', min_D, max_D);
            t = t + D;

            if CS_order(num_presentations+1) == 1
                CS1_time = round(t/dt);
                CS1_times = [CS1_times; CS1_time];
                t = t + CS1_L;
            else
                CS2_time = round(t/dt);
                CS2_times = [CS2_times; CS2_time];
                t = t + CS2_L;
            end

            num_presentations = num_presentations + 1;
        end

        % retrieval phase

        % 4 presentations of CS1 with -20% inhibition

        num_presentations = 0;
        while num_presentations < 4
            % get the next presentation start time
            D = random('Uniform', min_D, max_D);
            t = t + D;

            CS1_time = round(t/dt);
            CS1_times = [CS1_times; CS1_time];
            t = t + CS1_L;

            if ~excitation
                inhibition_stim_time = round(t/dt);
                inhibition_stim_times = [inhibition_stim_times; inhibition_stim_time];
            end

            num_presentations = num_presentations + 1;
        end
    end

    % generate US_t, CS1_t, CS2_t

    % calculate length of training (s)
    T = ceil(max([US_times(end) + US_L/dt, CS1_times(end) + CS1_L/dt]))*dt;

    US_t  = zeros(ceil(T/dt), 1); % vector showing when US is shown (1 if US is present, 0 if not)
    CS1_t = zeros(ceil(T/dt), 1); % vector showing when CS1 is shown (1 if CS1 is present, 0 if not)
    CS2_t = zeros(ceil(T/dt), 1); % vector showing when CS2 is shown (1 if CS2 is present, 0 if not)
    inhib_t = ones(ceil(T/dt), 1);

    for j=1:length(inhibition_stim_times)
        inhibition_stim_time = inhibition_stim_times(j);
        if j <= 108
            inhib_t(inhibition_stim_time:inhibition_stim_time + round(stim_L/dt)) = 0.8;
        end
    end

    for i = 1:length(US_times)
        US_start = US_times(i);
        US_t(US_start:US_start+US_L/dt) = 1;
    end
    for i = 1:length(CS1_times)
        CS1_start = CS1_times(i);
        CS1_t(CS1_start:CS1_start+CS1_L/dt) = 1;

        if ~excitation && i == 22
            inhib_t(CS1_start:end) = 0.8;
        end
    end
    for i = 1:length(CS2_times)
        CS2_start = CS2_times(i);
        CS2_t(CS2_start:CS2_start+CS2_L/dt) = 1;
    end

    nsteps  = ceil(T/dt);

    % create I2E_scale array
    I2E_scale_array = ones(nsteps, 1);
    if excitation
        for j=1:length(activation_stim_times)
            activation_stim_time = activation_stim_times(j);
            I2E_scale_array(activation_stim_time:activation_stim_time + round(CS1_L/dt)) = 1.1;
        end
    else
        I2E_scale_array = inhib_t;
    end
elseif paradigm_flag == 4 % categorization
    n_epochs = 50;

    T = n_epochs*10*US_L; % length of training (s)

    CS3_units  = [2*num_active+1:3*num_active];
    CS4_units  = [3*num_active+1:4*num_active];
    CS5_units  = [4*num_active+1:5*num_active];
    CS6_units  = [5*num_active+1:6*num_active];
    CS7_units  = [6*num_active+1:7*num_active];
    CS8_units  = [7*num_active+1:8*num_active];
    CS9_units  = [8*num_active+1:9*num_active];
    CS10_units = [9*num_active+1:10*num_active];

    US_t   = zeros(ceil(T/dt), 1);
    CS1_t  = zeros(ceil(T/dt), 1);
    CS2_t  = zeros(ceil(T/dt), 1);
    CS3_t  = zeros(ceil(T/dt), 1);
    CS4_t  = zeros(ceil(T/dt), 1);
    CS5_t  = zeros(ceil(T/dt), 1);
    CS6_t  = zeros(ceil(T/dt), 1);
    CS7_t  = zeros(ceil(T/dt), 1);
    CS8_t  = zeros(ceil(T/dt), 1);
    CS9_t  = zeros(ceil(T/dt), 1);
    CS10_t = zeros(ceil(T/dt), 1);

    US_times   = [];
    CS1_times  = [];
    CS2_times  = [];
    CS3_times  = [];
    CS4_times  = [];
    CS5_times  = [];
    CS6_times  = [];
    CS7_times  = [];
    CS8_times  = [];
    CS9_times  = [];
    CS10_times = [];

    t = US_L;
    last_CS = 1;
    while t < T
        a = round(mod(t/US_L, 10));

        if a == 0 || a == 10
            CS1_time = round(t/dt);
            CS1_times = [CS1_times; CS1_time];
            CS1_t(CS1_time+1:CS1_time+US_L/dt) = 1;

            if num_rewarded > 0
                US_time = round(t/dt);
                US_times = [US_times; US_time];
                US_t(US_time+1:US_time+US_L/dt) = 1;
            end
        elseif a == 1
            CS2_time = round(t/dt);
            CS2_times = [CS2_times; CS2_time];
            CS2_t(CS2_time+1:CS2_time+US_L/dt) = 1;

            if num_rewarded > 1
                US_time = round(t/dt);
                US_times = [US_times; US_time];
                US_t(US_time+1:US_time+US_L/dt) = 1;
            end
        elseif a == 2
            CS3_time = round(t/dt);
            CS3_times = [CS3_times; CS3_time];
            CS3_t(CS3_time+1:CS3_time+US_L/dt) = 1;

            if num_rewarded > 2
                US_time = round(t/dt);
                US_times = [US_times; US_time];
                US_t(US_time+1:US_time+US_L/dt) = 1;
            end
        elseif a == 3
            CS4_time = round(t/dt);
            CS4_times = [CS4_times; CS4_time];
            CS4_t(CS4_time+1:CS4_time+US_L/dt) = 1;

            if num_rewarded > 3
                US_time = round(t/dt);
                US_times = [US_times; US_time];
                US_t(US_time+1:US_time+US_L/dt) = 1;
            end
        elseif a == 4
            CS5_time = round(t/dt);
            CS5_times = [CS5_times; CS5_time];
            CS5_t(CS5_time+1:CS5_time+US_L/dt) = 1;

            if num_rewarded > 4
                US_time = round(t/dt);
                US_times = [US_times; US_time];
                US_t(US_time+1:US_time+US_L/dt) = 1;
            end
        elseif a == 5
            CS6_time = round(t/dt);
            CS6_times = [CS6_times; CS6_time];
            CS6_t(CS6_time+1:CS6_time+US_L/dt) = 1;

            if num_rewarded > 5
                US_time = round(t/dt);
                US_times = [US_times; US_time];
                US_t(US_time+1:US_time+US_L/dt) = 1;
            end
        elseif a == 6
            CS7_time = round(t/dt);
            CS7_times = [CS7_times; CS7_time];
            CS7_t(CS7_time+1:CS7_time+US_L/dt) = 1;

            if num_rewarded > 6
                US_time = round(t/dt);
                US_times = [US_times; US_time];
                US_t(US_time+1:US_time+US_L/dt) = 1;
            end
        elseif a == 7
            CS8_time = round(t/dt);
            CS8_times = [CS8_times; CS8_time];
            CS8_t(CS8_time+1:CS8_time+US_L/dt) = 1;

            if num_rewarded > 7
                US_time = round(t/dt);
                US_times = [US_times; US_time];
                US_t(US_time+1:US_time+US_L/dt) = 1;
            end
        elseif a == 8
            CS9_time = round(t/dt);
            CS9_times = [CS9_times; CS9_time];
            CS9_t(CS9_time+1:CS9_time+US_L/dt) = 1;

            if num_rewarded > 8
                US_time = round(t/dt);
                US_times = [US_times; US_time];
                US_t(US_time+1:US_time+US_L/dt) = 1;
            end
        elseif a == 9
            CS10_time = round(t/dt);
            CS10_times = [CS10_times; CS10_time];
            CS10_t(CS10_time+1:CS10_time+US_L/dt) = 1;

            if num_rewarded > 9
                US_time = round(t/dt);
                US_times = [US_times; US_time];
                US_t(US_time+1:US_time+US_L/dt) = 1;
            end
        end

        t = t + US_L;
    end
elseif paradigm_flag == 5 % learned irrelevance

    US_times  = []; % start times of US presentations (timesteps)
    CS1_times = []; % start times of CS1 presentations (timesteps)

    if preexposure
        num_presentations = 100;

        T_preexposure = 800;
        
        % determine time steps when US is shown, from a uniform distribution
        US_times  = sort(round(random('Uniform', 1, (T_preexposure - US_L)/dt, num_presentations, 1)));
        
        % determine time steps when CS1 is shown, from a uniform distribution
        CS1_times = sort(round(random('Uniform', 1, (T_preexposure - CS1_L)/dt, num_presentations, 1)));
    else
        T_preexposure = 0;
    end

    t = T_preexposure;

    % show US and CS1 together 50 times

    num_presentations = 0;
    D = 5;
    while num_presentations < 100
        t = t + D;
         
        US_time = round(t/dt);
        US_times = [US_times; US_time];
 
        CS1_time = US_time - US_D/dt;
        CS1_times = [CS1_times; CS1_time];
 
        num_presentations = num_presentations + 1;
    end

    % calculate length of training (s)
    T = ceil(max([US_times(end) + US_L/dt, CS1_times(end) + CS1_L/dt]))*dt;

    US_t  = zeros(ceil(T/dt), 1); % vector showing when US is shown (1 if US is present, 0 if not)
    CS1_t = zeros(ceil(T/dt), 1); % vector showing when CS1 is shown (1 if CS1 is present, 0 if not)
    CS2_t = zeros(ceil(T/dt), 1); % vector showing when CS2 is shown (1 if CS2 is present, 0 if not)

    for i = 1:length(US_times)
        US_start = US_times(i);
        US_t(US_start:US_start+US_L/dt) = 1;
    end
    for i = 1:length(CS1_times)
        CS1_start = CS1_times(i);
        CS1_t(CS1_start:CS1_start+CS1_L/dt) = 1;
    end

    % CS2 is not shown
    CS2_times = [];
end
