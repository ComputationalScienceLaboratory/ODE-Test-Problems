function J = jacobian(~, x, a, B, C)

r = length(a);

J = B;

for i = 1:r
    J(i, :) = J(i, :) + (x.'*C(:, :, i)) + (C(:, :, i)*x).';
end

% Cmat = reshape(C, r, []);
% Cx = reshape(x.' * Cmat, r, r);
% Cy = reshape(reshape(permute(C, [1, 3, 2]), [], r) * x, r, r);
% J = B + Cx.' + Cy.';

end
