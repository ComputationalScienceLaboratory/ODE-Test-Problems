function [f, df, d2f] = wendlandWeC2PD1(k)

f = ((1 - k).^3).*(3*k + 1);
df = -12*((1 - k).^2).*k;
d2f = 12*(k - 1).*(3*k - 1);

end
