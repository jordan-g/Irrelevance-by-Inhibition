function sv = smoothEEG(v, w)
% sv = smoothEEG(v, w)
% smooths a vector v by convolving it with a gausian of width w
%
% if "v" is a matrix, each row is treated as a separate vector
%
% nei 4/07
% modified 5/11 to deal with matrices -nei

w = floor(w / 2) * 2;
kernel = gausswin(w);


%first convolve the vector by a gausian...
s = 0;
if size(v,2) == 1
    v = v';
    s = 1;
end
sv = v;

for i = 1:size(v,1)      
    exco = v(i,:);
    exco = double(exco);
    newex = conv(exco, kernel);
    someex = sum(exco);

% now normalize back to baseline values...
    somenewex = sum(newex);
    ex = newex*someex/somenewex;

%now remove the tails of the vector created by the convolution
    ex = ex(w/2:end-w/2);

    sv(i,1:length(ex)) = ex;
end
if s == 1
    sv = sv';
end
