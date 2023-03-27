function [f, df] = firstinversefn(k)

f = 2./(1 + k) - 1;
df = -2./((1+k).^2);

end
