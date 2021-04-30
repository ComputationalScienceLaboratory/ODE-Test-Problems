function dy = f(t, y, D, x)

hIn = length(y);

forcingTerm = (t - x) / (1 + t)^2;

forcingTerm(1) = forcingTerm(1) + (hIn / (1 + t));

dy = D * y + forcingTerm;

end

