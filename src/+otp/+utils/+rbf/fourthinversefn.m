function [f, df] = fourthinversefn(k)

f = -6./(1 + k.^4) + 8./(1 + k.^3) - 1;
df = 24*(k.^2).*(-1./((1 + k.^3).^2) + k./((1 + k.^4).^2));

end
