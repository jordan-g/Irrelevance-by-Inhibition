%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% hyperparameters.m
%
% This is the script to set network hyperparameters for the simulations described 
% in Insel, Guerguiev and Richards (2018). Parameters controlling the simulations 
% are given in the start of the main_script.m file, which also runs the simulations.

% unit numbers
num_x = 1000; % number input units
num_E = 800;  % number excitatory units
num_I = 1;    % number inhibitory units
num_y = 10;   % number output units

% simulation time constants
dt    = 0.02; % time step (s)
CS1_L = 0.2;  % length of CS1 presentations (s)
CS2_L = 0.2;  % length of CS2 presentations (s)
US_L  = 0.2;  % length of US presentations (s)
US_D  = 0.1;  % delay period between CS and US (s)

% relevance learning parameters
gamma     = 0.4; % the discounting fator
I_floor   = 0.1; % inhibitory floor - this is necessary to prevent div by zero
I_scale   = 1;   % scaling applied to inhibition on excitatory units
I2E_scale = 1;   % multiplicative scaling applied to inhibition on excitatory units
H         = 6.5; % relevance set-point in Hz
A         = 1.4; % scaling variable for increased activity for relevant stimuli in Hz
B         = 3;   % scaling variable for increased amygdala output to US
lambda_r  = 0.0; % eligibility trace accumulation variable, i.e. for TD(lambda)

% learning rates
alpha_r = 0.075; % learning rate for relevance learning
alpha_y = 0.0;   % learning rate for output learning

% weight initialization parameters
mu_x2E     = 0.3; % mean for initial input-to-excitatory weights, Gaus dist.
sigma_x2E  = 0.4; % standard deviation for initial input-to-excitatory weights, Gaus dist.
a_x2I      = 0.5; % amplitude for initial input-to-inhibitory weights
a_I2E      = 0.4; % amplitude for initial inhibitory-to-excitatory weights
mu_E2y     = 0.3; % mean for initial excitatory-to-output weights, Gaus dist.
sigma_E2y  = 0.4; % standard deviation for initial excitatory-to-output weights, Gaus dist.

% output learning paramaters
theta = H/4; % threshold parameter for amygdala output
kappa = 20;  % scaling parameter for softmax output                        

% input firing rate parameters
phi_on        = 20;  % firing rate of active input units (Hz)
phi_off_shape = 0.6; % shape of gamma distribution for firing rates of inactive units
phi_off_scale = 3;   % scale of gamma distribution for firing rates of inactive units

% desired correlations between conditioned stimuli and unconditioned stimulus
% 1: deterministic
% 0: uncorrelated
CS1_r = 1;
CS2_r = 0;
