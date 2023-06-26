function [Ja, JB, JC] = partialDerivativeParameters(~, y, ~, ~, ~)

r = size(y, 1);

Ja = speye(r);
JB = kron(y.', speye(r));
JC = kron(kron(speye(r), y.'), y.');

if nargout < 2
    Ja = [Ja, JB, JC];
end

end
