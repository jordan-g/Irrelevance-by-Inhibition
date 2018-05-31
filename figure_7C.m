%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% figure_7C.m
%
% This is the script to create Figure 7C in Insel, Guerguiev and Richards (2018).
% Parameters controlling the simulations are given in the start of the main_script.m
% file, which also runs the simulations.

y_max_left  = 100;
y_max_right = 50;

figure;

% ---- Test error ---------------------------------------------------------------%

% get test error
y = mean(all_test_acc, 1);
y_max = y + std(all_test_acc);
y_min = y - std(all_test_acc);

% generate x
x = linspace(1, size(all_test_acc, 2), size(all_test_acc, 2))*(US_L/dt)*dt;

% plot data
yyaxis left
plot(x, y, 'Color', [0.0, 0.5, 1.0]);
hold on
X = [x, fliplr(x)];
Y = [y_max, fliplr(y_min)];
h = fill(X, Y, [0.0, 0.5, 1.0]);
set(h, 'facealpha', .2);
set(h, 'EdgeColor', 'none');
ylabel('Correct categorization (%)');

% set plot properties
axis([0, 50, 0, y_max_left]);

% ---- Cross entropy ------------------------------------------------------------%

% get cross entropy
y_offset = phi_on*log(phi_on);
y = movmean(mean(cross_entropy, 1) + y_offset, 100);
y_max = movmean(mean(cross_entropy) + std(cross_entropy) + y_offset, 100);
y_min = movmean(mean(cross_entropy) - std(cross_entropy) + y_offset, 100);
x = linspace(1, size(y, 2), size(y, 2))*dt;

% plot data
yyaxis right
plot(x, y, 'Color', [1.0, 0.5, 0]);
hold on
a = cross_entropy;
X = [x, fliplr(x)];
Y = [y_max, fliplr(y_min)];
h = fill(X, Y, [1.0, 0.5, 0]);
set(h, 'facealpha', .2);
set(h, 'EdgeColor', 'none');
ylabel('Cross-entropy loss');

% set plot properties
axis([0, 50, 0, y_max_right]);

title('Categorization learning');
xlabel('Time (s)');

% save figure
print('figure_7C', '-dpng');
print('figure_7C', '-dsvg');