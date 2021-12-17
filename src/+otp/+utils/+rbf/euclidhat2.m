function [f, df] = euclidhat2(k)

f = (2/pi)*(acos(k) - k.*sqrt(1 - k.^2));

df = -(4/pi)*sqrt(1 - k.^2);

end
