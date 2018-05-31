%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% init.m
%
% This is the script to init dynamic variables for the simulations described in Insel, 
% Guerguiev and Richards (2018). Parameters controlling the simulations are given 
% are given in main_script.m, and hyperparameters for the network are given in
% hyperparameters.m. These variables are updated in train.m and test.m. 

% determine how many steps to run training for
nsteps  = ceil(T/dt);
alltime = [dt:dt:T];

% initialize x -> E weights
if paradigm_flag == 2
	W_x2E = smoothEEG(eye(num_E, num_x), round(num_x)/20) * num_x/3;
else
	W_x2E = random('norm', mu_x2E, sigma_x2E, num_E, num_x);
end
W_x2E(W_x2E < 0) = 0;

% initialize x -> I weights
W_x2I = a_x2I*ones(num_I, num_x);

% initialize I -> E weights
W_I2E = a_I2E*ones(num_E, num_I);

% initialize E -> y weights
if paradigm_flag == 2
	W_E2y = rand(num_y, num_E);   
    W_E2y = W_E2y./repmat(sqrt(sum(W_E2y.^2, 2)), 1, num_E);
elseif paradigm_flag == 4
	W_E2y = random('uniform', 0, 1, num_y, num_E);
else
	W_E2y = random('norm', mu_E2y, sigma_E2y, num_y, num_E);
end
W_E2y(W_E2y < 0) = 0;

% initialize biases
b_I   = zeros(num_I, 1);
b_E   = zeros(num_E, 1);
b_y   = zeros(num_y, 1);

% initialize update variables
delta_W_x2I = zeros(size(W_x2I));
delta_W_x2E = zeros(size(W_x2E));
delta_W_I2E = zeros(size(W_I2E));
delta_W_E2y = zeros(size(W_E2y));
delta_b_E   = zeros(size(b_E));
delta_b_I   = zeros(size(b_I));
delta_b_y   = zeros(size(b_y));

% determine the baseline firing rate of each neuron when no CS is present
seed_phi_x = gamrnd(phi_off_shape,phi_off_scale, [num_x, 1] );

% set pre-training flag
pretraining = true;

% save original hyperparameters
orig_learning_flag = learning_flag;
orig_alpha_r = alpha_r;

if T_pre > 0
	% pre-train, updating W_x2I only
	nsteps = ceil(T_pre/dt);
	learning_flag = 0;
	alpha_r = 0.2;

	% initialize dynamic variables for pre-training
	phi_x = zeros(num_x,nsteps); % input firing rates
	x     = zeros(num_x,nsteps); % input spike counts
	a_x   = zeros(num_x,nsteps); % eligibility traces for input
	phi_E = zeros(num_E,nsteps); % excitatory firing rates
	E     = zeros(num_E,nsteps); % excitatory spike counts
	I     = zeros(num_I,nsteps); % inhibitory activity
	a_I   = zeros(num_I,nsteps); % eligibility traces for inhibitory cells
	z     = zeros(num_y,nsteps); % output linear input
	phi_y = zeros(num_y,nsteps); % output firing rates
	y     = zeros(num_y,nsteps); % output spike counts/activity
	o     = zeros(num_y,nsteps); % output targets (for category learning)
	beta  = zeros(1,nsteps);     % relevance prediction error
	S     = zeros(1,nsteps);     % relevance signal
	L     = zeros(1,nsteps);     % loss function for categorization

	pretrain;
end

% reset pre-train flag
pretraining = false;

% restore original hyperparameters
learning_flag = orig_learning_flag;
alpha_r = orig_alpha_r;
nsteps  = ceil(T/dt);

% initialize dynamic variables for training
phi_x    = zeros(num_x,nsteps);             % input firing rates
x        = zeros(num_x,nsteps);             % input spike counts
a_x      = zeros(num_x,nsteps);             % eligibility traces for input
phi_E    = zeros(num_E,nsteps);             % excitatory firing rates
E        = zeros(num_E,nsteps);             % excitatory spike counts
I        = zeros(num_I,nsteps);             % inhibitory activity
a_I      = zeros(num_I,nsteps);             % eligibility traces for inhibitory cells
z        = zeros(num_y,nsteps);             % output linear input
phi_y    = zeros(num_y,nsteps);             % output firing rates
y        = zeros(num_y,nsteps);             % output spike counts/activity
o        = zeros(num_y,nsteps);             % output targets (for category learning)
beta     = zeros(1,nsteps);                 % relevance prediction error
S        = zeros(1,nsteps);                 % relevance signal
L        = zeros(1,nsteps);                 % loss function for categorization
test_acc = zeros(1,ceil(nsteps/(US_L/dt))); % test accuracy for categorization