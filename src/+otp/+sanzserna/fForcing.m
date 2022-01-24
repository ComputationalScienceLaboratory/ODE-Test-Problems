function dy = fForcing(t, y, ~, x)

hInv = size(y, 1);

dy = (t - x)/((1 + t)^2);

dy(1, :) = dy(1, :) + (hInv/(1 + t));

end

