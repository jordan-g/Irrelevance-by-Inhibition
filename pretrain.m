%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% pretrain.m
%
% This is the script to run pre-training for the simulations described in Insel, 
% Guerguiev and Richards (2018). Parameters controlling the simulations are given 
% are given in main_script.m, and hyperparameters for the network are given in
% hyperparameters.m. 

% print a message
fprintf('Beginning pre-training for %07.2f s...\n', nsteps*dt);

% pre-train for T_pre seconds (nsteps)
for t = 1:nsteps
	% print a message
	if t == 1
		fprintf('Pre-training time = %07.2f s',t*dt);
	elseif mod(t,10) == 0
		fprintf('\b\b\b\b\b\b\b\b\b');
		fprintf('%07.2f s',t*dt);
	end

	% determine current inputs
 	if paradigm_flag == 4
		phi_x(:, t) = 0.3;
	elseif paradigm_flag == 2
		phi_x(:, t) = seed_phi_x;
		phi_x(CS1_units, t) = 0.3;
	else
		phi_x(:, t) = seed_phi_x;
		phi_x(CS1_units, t) = 0.3;
		phi_x(CS2_units, t) = 0.3;
	end

	x(:, t) = random('pois', phi_x(:, t)*dt);

	% propagate input activity to inhibitory and excitatory units
	if use_bias
		I(:,t)     = (W_x2I*x(:,t))*dt;
		phi_E(:,t) = (W_x2E*x(:,t))./(W_I2E*I(:,t) + I_floor);

		if I_scale < 1
			phi_E(:,t) = I_scale*phi_E(:, t) + (1.0 - I_scale)*(W_x2E*x(:,t));
		end
	else
		I(:,t)     = (W_x2I*x(:,t) + b_I)*dt;
		phi_E(:,t) = (W_x2E*x(:,t) + b_E)./(W_I2E*I(:,t) + I_floor);

		if I_scale < 1
			phi_E(:,t) = I_scale*phi_E(:, t) + (1.0 - I_scale)*(W_x2E*x(:,t) + b_E);
		end
	end

	e = random('pois', phi_E(:,t)*dt);
	e(e > 1) = 1; % don't allow more than one spike per timestep
	E(:, t) = e;

	% calculate relevance signal, prediction error and eligibility
	S(t) = norm(E(:,t)) - H;
	if t == 1
		beta(t)  = gamma*S(t);
		a_x(:,t) = 0;
		a_I(:,t) = 0;
	elseif t == 2
		beta(t)  = gamma*S(t) - S(t-1);
 		a_x(:,t) = alpha_r*x(:,t-1);
 		a_I(:,t) = alpha_r*I(:,t-1);
	else
		beta(t)  = gamma*S(t) - S(t-1);
 		a_x(:,t) = gamma*lambda_r*a_x(:,t-2) + alpha_r*x(:,t-1);
 		a_I(:,t) = gamma*lambda_r*a_I(:,t-2) + alpha_r*I(:,t-1);
	end

	% update the network parameters
	update;
end

% print a message
fprintf('\n');
fprintf('Finished pre-training.\n');