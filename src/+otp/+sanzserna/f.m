function dy = f(t, y, D, x)

hInv = size(y, 1);

forcingTerm = (t - x)/((1 + t)^2);

forcingTerm(1) = forcingTerm(1) + (hInv/(1 + t));

dy = D*y + forcingTerm;

end

