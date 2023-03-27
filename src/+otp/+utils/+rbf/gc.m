function [f, df] = gc(k)

f = zeros(size(k));
df = zeros(size(k));

theta = 1/2;

mask1 = k <= theta;
mask2 = and((k > theta), (k <= 2*theta));

km1 = k(mask1)/theta;
km2 = k(mask2)/theta;

f(mask1) = ones(size(km1)) - (5/3)*(km1.^2) + (5/8) * (km1.^3) + (1/2)*(km1.^4) - (1/4)*(km1.^5);
f(mask2) = 4*ones(size(km2)) - 5*km2 + (5/3)*(km2.^2) + (5/8)*(km2.^3) - (1/2)*(km2.^4) + (1/12)*(km2.^5) - (2./(3*km2));

df(mask1) = - (10/3)*(km1/theta) + (15/8) * (km1.^2)/theta + (2)*(km1.^3)/theta - (5/4)*(km1.^4)/theta;
df(mask2) = - 5/theta + (10/3)*(km2)/theta + (15/8)*(km2.^2)/theta - (2)*(km2.^3)/theta + (5/12)*(km2.^4)/theta + (2./(3*(km2.^2)))/theta;

f(isinf(f)) = 0;
df(isinf(df)) = 0;

end
