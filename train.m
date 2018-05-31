%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% train.m
%
% This is the script to run training of the simulations described in Insel, 
% Guerguiev and Richards (2018). Parameters controlling the simulations are given 
% are given in main_script.m, and hyperparameters for the network are given in
% hyperparameters.m. 

% print a message
fprintf('Beginning training for %07.2f s...\n', nsteps*dt);

% train for T seconds (nsteps)
for t = 1:nsteps
	% print a message
	if t == 1
		fprintf('Training time = %07.2f s',t*dt);
	elseif mod(t,10) == 0
		fprintf('\b\b\b\b\b\b\b\b\b');
		fprintf('%07.2f s',t*dt);
	end

	% determine current inputs (and target outputs if required)
	phi_x(:, t) = seed_phi_x;

	if CS1_t(t) == 1, phi_x(CS1_units,t) = phi_on; end;
	if CS2_t(t) == 1, phi_x(CS2_units,t) = phi_on; end; 

	if paradigm_flag == 4
		if CS1_t(t), o(1,t) = kappa; end;
		if CS2_t(t), o(2,t) = kappa; end;
		if CS3_t(t), phi_x(CS3_units,t) = phi_on; o(3,t) = kappa; end;
		if CS4_t(t), phi_x(CS4_units,t) = phi_on; o(4,t) = kappa; end;
		if CS5_t(t), phi_x(CS5_units,t) = phi_on; o(5,t) = kappa; end;
		if CS6_t(t), phi_x(CS6_units,t) = phi_on; o(6,t) = kappa; end;
		if CS7_t(t), phi_x(CS7_units,t) = phi_on; o(7,t) = kappa; end;
		if CS8_t(t), phi_x(CS8_units,t) = phi_on; o(8,t) = kappa; end;
		if CS9_t(t), phi_x(CS9_units,t) = phi_on; o(9,t) = kappa; end;
		if CS10_t(t), phi_x(CS10_units,t) = phi_on; o(10,t) = kappa; end;
	end

	x(:, t) = random('pois', phi_x(:, t)*dt);
	
	if paradigm_flag == 2
		% in the latent inhibition paradigm, I_scale changes during training
		I_scale = I_scale_array(t);
	elseif paradigm_flag == 3
		% in the fear expression paradigm, I2E_scale changes during training
		I2E_scale = I2E_scale_array(t);
	end

	% propagate input activity to inhibitory and excitatory units
	if use_bias
		I(:,t)     = (W_x2I*x(:,t) + b_I)*dt;
		phi_E(:,t) = (W_x2E*x(:,t) + b_E)./(I2E_scale*(W_I2E*I(:,t) + I_floor));

		if I_scale < 1
			phi_E(:,t) = I_scale*phi_E(:, t) + (1.0 - I_scale)*(W_x2E*x(:,t) + b_E);
		end
	else
		I(:,t)     = (W_x2I*x(:,t))*dt;
		phi_E(:,t) = (W_x2E*x(:,t))./(I2E_scale*(W_I2E*I(:,t) + I_floor));

		if I_scale < 1
			phi_E(:,t) = I_scale*phi_E(:, t) + (1.0 - I_scale)*(W_x2E*x(:,t));
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
		beta(t)  = A*US_t(t-1) + gamma*S(t) - S(t-1);
 		a_x(:,t) = alpha_r*x(:,t-1);
 		a_I(:,t) = alpha_r*I(:,t-1);
	else
		beta(t)  = A*US_t(t-1) + gamma*S(t) - S(t-1);
 		a_x(:,t) = gamma*lambda_r*a_x(:,t-2) + alpha_r*x(:,t-1);
 		a_I(:,t) = gamma*lambda_r*a_I(:,t-2) + alpha_r*I(:,t-1);
	end

	% propagate activity to output units
	if output_flag == 1 % amygdala output
		z(:, t) = W_E2y*E(:, t) - theta;
		y(:, t) = 0;
		if any(z(:, t) > 0) || US_t(t)
			[mz, iz] = max(z(:, t));
			y(iz, t) = mz + 0.5*US_t(t);
			y(y < 0) = 0;
		end
	elseif output_flag == 2 % softmax output
		z(:,t)     = W_E2y*E(:,t) + b_y;
		phi_y(:,t) = kappa*exp(z(:,t))./repmat(sum(exp(z(:,t))),num_y,1);
		y(:,t)     = poissrnd(phi_y(:,t)*dt);
	end

	% update the network parameters
	update;

	if ~pretraining && output_flag == 2 && mod(t, US_L/dt) == 0
		% for categorization, test the network
		test;
	end
end

% print a message
fprintf('\n');
fprintf('Finished training.\n');
