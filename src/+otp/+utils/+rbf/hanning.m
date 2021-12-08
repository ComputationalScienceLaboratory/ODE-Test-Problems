function [f, df] = hanning(k)

f = cospi(k) + 1;
df = -sinpi(k);

end
