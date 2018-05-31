%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% update.m
%
% This is the sript to update the synaptic weight parameters for simulations
% described in Insel, Guerguiev and Richards (2018). Hyperparameters for the
% updates are given in hyperparameters.m.

% relevance learning
if learning_flag == 0 % learning on W_x2I
	delta_W_x2I = -repmat((beta(t)*a_x(:,t))',num_I,1);
	delta_W_x2E = zeros(size(W_x2E));
	delta_W_I2E = zeros(size(W_I2E));
	delta_b_E   = zeros(size(b_E));
 	delta_b_I   = -alpha_r*beta(t);
elseif learning_flag == 1 % learning on W_x2E
	delta_W_x2I = zeros(size(W_x2I));
	delta_W_x2E = repmat((beta(t)*a_x(:,t))',num_E,1);
	delta_W_I2E = zeros(size(W_I2E));
	delta_b_E   = alpha_r*beta(t);
	delta_b_I   = zeros(size(b_I));
elseif learning_flag == 2 % learning on W_I2E
	delta_W_x2I = zeros(size(W_x2I));
	delta_W_x2E = zeros(size(W_x2E));
	delta_W_I2E = -repmat((beta(t)*a_I(:,t))',num_E,1);
	delta_b_E   = zeros(size(b_E));
	delta_b_I   = zeros(size(b_I));
end

% output learning
if output_flag == 1 && ~pretraining % amygdala output - competitive learning
    if any(y(:, t) > 0)
		delta_W_E2y = alpha_y*US_t(t)*repmat(y(:, t), 1, num_E).*(repmat(E(:, t)'/norm(E(:, t)), num_y, 1) - W_E2y);
    else
        delta_W_E2y = zeros(num_y, num_E);
    end
    
    W_E2y = W_E2y + delta_W_E2y/norm(E(:, t));
    
    W_E2y(W_E2y < 0) = 0;

    W_E2y = W_E2y./repmat(sqrt(sum(W_E2y.^2, 2)), 1, num_E);

    y(:, t) = y(:, t)/sum(z(:, t));
elseif output_flag == 2 && ~pretraining % softmax output - backprop
	L(t)         = -sum(o(:,t).*log(phi_y(:,t)));
    dL_by_dz     = kappa*(phi_y(:,t) - o(:,t)); % derivative of cross-entropy w.r.t. z if phi_y is softmax
	dL_by_dW_E2y = dL_by_dz*phi_E(:,t)';
	dL_by_db_y   = dL_by_dz;
	dz_by_dE     = W_E2y;
	dE_by_dW_x2E = phi_x(:,t);
	dL_by_dW_x2E = dz_by_dE'*dL_by_dz*dE_by_dW_x2E';
	dL_by_db_E   = dz_by_dE'*dL_by_dz;
	
	delta_W_E2y = -alpha_y*dL_by_dW_E2y;  
	delta_W_x2E = -alpha_y*dL_by_dW_x2E;  
	delta_b_y   = -alpha_y*dL_by_db_y;  
	delta_b_E   = -alpha_y*dL_by_db_E;  
    
    W_E2y = W_E2y + delta_W_E2y;
    b_y   = b_y   + delta_b_y;

    W_E2y(W_E2y < 0) = 0;
    b_y(b_y < 0) = 0;
end

% update weights
W_x2I = W_x2I + delta_W_x2I;
W_x2E = W_x2E + delta_W_x2E;
W_I2E = W_I2E + delta_W_I2E;
b_E   = b_E   + delta_b_E;
b_I   = b_I   + delta_b_I;

% ensure positive weights
W_x2I(W_x2I < 0) = 0;
W_x2E(W_x2E < 0) = 0;
W_I2E(W_I2E < 0) = 0;
b_E(b_E < 0) = 0;
b_I(b_I < 0) = 0;
