%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% figure_3B.m
%
% This is the script to create Figure 3B in Insel, Guerguiev and Richards (2018).
% Parameters controlling the simulations are given in the start of the main_script.m
% file, which also runs the simulations.

y_max_I = 20;
y_max_E = 5;

exp_name = ('x_I');

figure;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ---- Last stimulus presentation CS1 -------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

last_CS1_time    = all_CS1_times.(exp_name)(1, end); % get the last CS1 presentation
last_CS1_second  = floor(last_CS1_time*dt);          % calculate what the last second was before CS1 presentation
last_US_time     = all_US_times.(exp_name)(1, end);  % get the last US presentation

% set x limits (in timesteps)
x_limits = [max(1, last_CS1_second/dt), min((last_CS1_second + 1.5)/dt, size(mean_I.(exp_name), 2))];

% generate a range of values spanning the x limits
x = linspace(x_limits(1), x_limits(2), x_limits(2) - x_limits(1));

% ---- I(t) ---------------------------------------------------------------------%

% plot I data
subplot(2, 2, 1);
plot(x, mean_I.(exp_name)(1, x_limits(1):x_limits(2)-1), 'k');

% set plot properties
axis([x_limits(1), x_limits(2), 0, y_max_I]);
title('Last stimulus presentation');
xticks([x_limits(1), x_limits(1) + 1.0/dt]);
xticklabels({sprintf('%d', last_CS1_second), sprintf('%d', last_CS1_second + 1)});
ylabel('Cortical firing rates (Hz)');

% ---- E(t) ---------------------------------------------------------------------%

% plot E data
subplot(2, 2, 3);
plot(x, mean_phi_E.(exp_name)(1, x_limits(1):x_limits(2)-1), 'k');

% plot rectangle showing when CS1 occurred
patch([last_CS1_time, last_CS1_time + CS1_L/dt, last_CS1_time + CS1_L/dt, last_CS1_time], [0, 0, 1.5, 1.5], [0, 0.6, 0], 'FaceAlpha', 0.5, 'EdgeColor', 'none');

% set plot properties
axis([x_limits(1), x_limits(2), 0, y_max_E]);
xticks([x_limits(1), x_limits(1) + 1.0/dt]);
xticklabels({sprintf('%d', last_CS1_second), sprintf('%d', last_CS1_second + 1)});
xlabel('Time (s)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ---- Last stimulus presentation CS2 -------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

last_CS2_time   = all_CS2_times.(exp_name)(1, end); % get the last CS2 presentation
last_CS2_second = floor(last_CS2_time*dt);          % calculate what the last second was before CS2 presentation

% set x limits (in timesteps)
x_limits = [max(last_CS2_second/dt, 1), min((last_CS2_second + 1.5)/dt, size(mean_I.(exp_name), 2))];

% generate a range of values spanning the x limits
x = linspace(x_limits(1), x_limits(2), x_limits(2) - x_limits(1));

% ---- I(t) ---------------------------------------------------------------------%

% plot I data
subplot(2, 2, 2);
plot(x, mean_I.(exp_name)(1, x_limits(1):x_limits(2)-1), 'k');

% set plot properties
axis([x_limits(1), x_limits(2), 0, y_max_I]);
xticks([x_limits(1), x_limits(1) + 1.0/dt]);
xticklabels({sprintf('%d', last_CS2_second), sprintf('%d', last_CS2_second + 1)});

% ---- E(t) ---------------------------------------------------------------------%

% plot E data
subplot(2, 2, 4);
plot(x, mean_phi_E.(exp_name)(1, x_limits(1):x_limits(2)-1), 'k');

% plot rectangle showing when CS2 occurred
patch([last_CS2_time, last_CS2_time + CS2_L/dt, last_CS2_time + CS2_L/dt, last_CS2_time], [0, 0, 1.5, 1.5], [1.0, 0.5, 0], 'FaceAlpha', 0.5, 'EdgeColor', 'none');

% set plot properties
axis([x_limits(1), x_limits(2), 0, y_max_E]);
xticks([x_limits(1), x_limits(1) + 1.0/dt]);
xticklabels({sprintf('%d', last_CS2_second), sprintf('%d', last_CS2_second + 1)});

% save figure
print('figure_3B', '-dpng');
print('figure_3B', '-dsvg');
