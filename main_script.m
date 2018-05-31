%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% main_script.m
%
% This is the main script to run for the simulations described in Insel, Guerguiev
% and Richards (2018). Parameters controlling the simulations are given in
% start of this file. Network hyperparameters are determined in the script
% hyperparameters.m.

% NOTE: In order to reproduce any of the figures in the paper, simply run any of
%       the following files instead:
%       - learning_to_ignore.m
%       - blocking.m
%       - latent_inhibition.m
%       - fear_expression.m
%       - categorization.m
%       - learned_irrelevance.m
%
% Otherwise, use this file to run a custom simulation.

% flag for what the output units should be
% 0: no output units
% 1: amygdala outputs
% 2: softmax outputs
output_flag = 0;

% flag for which weights to update
% 0: update x -> I weights
% 1: update x -> E weights
% 2: update I -> E weights
learning_flag = 0;

% flag for which training paradigm to use
% 0: learning to ignore
% 1: blocking
% 2: latent inhibition
% 3: fear expression
% 4: categorization
% 5: learned irrelevance
paradigm_flag = 0;

% flag for whether to use bias terms
use_bias = false;

% create hyperparameters
hyperparameters;

% set extra flags depending on the paradigm
if paradigm_flag == 2
	preexposure             = true;  % whether to have a preexposure phase
	inhibition_conditioning = false; % whether to do -20% inhibition during conditioning
	inhibition_test         = false; % whether to do -20% inhibition during testing
elseif paradigm_flag == 3
	% flag for which experiment to run
	% 0: -20% inhibition pre-FC and post-extinction
    % 1: +10% inhibition post-FC
	experiment_flag = 0;
end

% create stimulus sequences
stimuli;

% initialize dynamic variables
init;

% train the network
train;
