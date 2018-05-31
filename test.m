%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% test.m
%
% This is the script to run testing in the categorization stimulations described in
% Insel, Guerguiev and Richards (2018). Parameters controlling the simulations are
% given are given in main_script.m, and hyperparameters for the network are given in
% hyperparameters.m. 

T_test = 10*US_L; % length of testing (s)

% determine how many steps to run testing for
nsteps_test = ceil(T_test/dt);

% initialize dynamic variables for testing
phi_x_test = zeros(num_x,nsteps_test);
x_test     = zeros(num_x,nsteps_test);
a_test     = zeros(num_x,nsteps_test);    
phi_E_test = zeros(num_E,nsteps_test);
E_test     = zeros(num_E,nsteps_test);
I_test     = zeros(num_I,nsteps_test);
z_test     = zeros(num_y,nsteps_test);
phi_y_test = zeros(num_y,nsteps_test);
y_test     = zeros(num_y,nsteps_test);
beta_test  = zeros(1,nsteps_test);
S_test     = zeros(1,nsteps_test);

accuracy    = 0;
stim_number = 0;
       
% train for T_test seconds (nsteps)
for t_test = 1:nsteps_test;
    % determine which stimulus to show
    if mod(t_test-1, US_L/dt) == 0
        stim_number  = stim_number + 1;
    end

    % determine current inputs
    phi_x_test(:,t_test) = gamrnd(phi_off_shape,phi_off_scale,[num_x,1]);
    
    if stim_number == 1, phi_x_test(CS1_units,t_test) = phi_on; end;
    if stim_number == 2, phi_x_test(CS2_units,t_test) = phi_on; end;
    if stim_number == 3, phi_x_test(CS3_units,t_test) = phi_on; end;
    if stim_number == 4, phi_x_test(CS4_units,t_test) = phi_on; end;
    if stim_number == 5, phi_x_test(CS5_units,t_test) = phi_on; end;
    if stim_number == 6, phi_x_test(CS6_units,t_test) = phi_on; end;
    if stim_number == 7, phi_x_test(CS7_units,t_test) = phi_on; end;
    if stim_number == 8, phi_x_test(CS8_units,t_test) = phi_on; end;
    if stim_number == 9, phi_x_test(CS9_units,t_test) = phi_on; end;
    if stim_number == 10, phi_x_test(CS10_units,t_test) = phi_on; end;

    x_test(:,t_test) = poissrnd(phi_x_test(:,t_test)*dt);

    % propagate input activity to inhibitory and excitatory units
    if use_bias
        I_test(:,t_test)     = (W_x2I*x_test(:,t_test) + b_I)*dt;
        phi_E_test(:,t_test) = (W_x2E*x_test(:,t_test) + b_E)./(I2E_scale*(W_I2E*I_test(:,t_test) + I_floor));

        if I_scale < 1
            phi_E_test(:,t_test) = I_scale*phi_E_test(:,t_test) + (1.0 - I_scale)*(W_x2E*x_test(:,t_test) + b_E);
        end
    else
        I_test(:,t_test)     = (W_x2I*x_test(:,t_test))*dt;
        phi_E_test(:,t_test) = (W_x2E*x_test(:,t_test))./(I2E_scale*(W_I2E*I_test(:,t_test) + I_floor));

        if I_scale < 1
            phi_E_test(:,t_test) = I_scale*phi_E_test(:,t_test) + (1.0 - I_scale)*(W_x2E*x_test(:,t_test));
        end
    end
    
    e_test = random('pois', phi_E_test(:,t_test)*dt);
    e_test(e_test > 1) = 1; % don't allow more than one spike per timestep
    E_test(:,t_test) = e_test;

    % propagate activity to output units
    z_test(:,t_test)     = W_E2y*E_test(:,t_test) + b_y;
    phi_y_test(:,t_test) = kappa*exp(z_test(:,t_test))./repmat(sum(exp(z_test(:,t_test))),num_y,1);
    y_test(:,t_test)     = poissrnd(phi_y_test(:,t_test)*dt);
end

% determine test accuracy
correct_count = 0;
for i=1:10
    avg_phi_y = mean(phi_y_test(:, round((i-1)*US_L/dt)+1:round(i*US_L/dt)), 2);

    [m, max_index] = max(avg_phi_y);

    if max_index == i
        correct_count = correct_count + 1;
    end
end

test_acc(floor(t/(US_L/dt))) = correct_count*10;