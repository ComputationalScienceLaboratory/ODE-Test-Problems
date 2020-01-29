function J = jac(~, x, B, C)

r = size(x, 1);

J = B;

for i = 1:r
    J(i, :) = J(i, :) + (x.'*C(:, :, i)) + (C(:, :, i)*x).';
end

end
