function dy = fforcing(t, y, ~, x)

hIn = length(y);

dy = (t - x) / (1 + t)^2;

dy(1) = dy(1) + (hIn / (1 + t));

end

