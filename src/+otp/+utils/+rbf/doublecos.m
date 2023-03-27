function [f, df] = doublecos(k)

f = 4*cospi(k) + cospi(2*k) + 3;

df = -2*pi*(2*sinpi(k) + sinpi(2*k));

end
