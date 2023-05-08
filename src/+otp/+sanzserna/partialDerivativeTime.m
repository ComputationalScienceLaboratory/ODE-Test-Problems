function jt = partialDerivativeTime(t, y, ~, x)

hInv = size(y, 1);

jt = (1 - t + 2*x)/((1 + t)^3);
jt(1, :) = jt(1, :) - hInv/((1 + t)^2);

end
