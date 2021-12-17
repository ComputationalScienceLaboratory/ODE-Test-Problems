function [f, df] = wendlandWeC2PD1(k)

f = ((1 - k).^3).*(3*k + 1);
df = -12*((1 - k).^2).*k;

end
