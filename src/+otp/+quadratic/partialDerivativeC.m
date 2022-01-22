function jC = partialDerivativeC(~, y, ~, ~, C)

r = size(C, 1);

jC = kron(kron(speye(r), y.'), y.');

end
