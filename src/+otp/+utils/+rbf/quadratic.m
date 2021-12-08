function [f, df] = quadratic(k)

k2 = k.*k;
k3 = k.*k2;
k4 = k.*k3;

f = 1 - 6*k2 + 8*k3 - 3*k4;
df = -12*k + 24*k2 - 12*k3;

end
