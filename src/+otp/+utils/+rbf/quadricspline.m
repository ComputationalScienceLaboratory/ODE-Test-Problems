function [f, df, d2f] = quadricspline(k)

k2 = k.*k;
k3 = k.*k2;
k4 = k.*k3;

f = (5/2)*(1 - 6*k2 + 8*k3 - 3*k4);
df = (5/2)*(-12*k + 24*k2 - 12*k3);
d2f = (5/2)*(-12 + 48*k - 36*k2);

end
