function [f, df] = buhmann3(k)

maskk0 = k == 0;

f = (1/3) + k.^2 - (4/3)*(k.^3) + 2*(k.^2).*log(k);
f(maskk0) = (1/3) + k(maskk0).^2 - (4/3)*(k(maskk0).^3);


df = 4*k - 4*(k.^2) + 4*k.*log(k);
df(maskk0) = 4*k(maskk0) - 4*(k(maskk0).^2);

end