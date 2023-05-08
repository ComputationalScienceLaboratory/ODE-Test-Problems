function jB = partialDerivativeB(~, y, ~, B, ~)

r = size(B, 1);

jB = kron(y.', speye(r));

end
