function dat = f(~, x, a, B, C)

r = size(x, 1);
s = size(x, 2);

% nonlinear term
N = zeros(r, s);

for si = 1:s
    for i = 1:r
        N(i, si) = x(:, si).'*C(:, :, i)*x(:, si);
    end
end

dMat = N + B*x + repmat(a, 1, s);

dat = dMat;

end
