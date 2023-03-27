function [f, df] = expdecay(k)

f = exp(-k) - exp(-1);

df = -exp(-k);

end
