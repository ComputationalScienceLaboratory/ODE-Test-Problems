function J = jacobianApproximation(f, t, y)
% TODO: make this more robust

n = numel(y);

J = zeros(n, n);

h = sqrt(1e-6);

f0 = f(t, y);

for i = 1:n
    e = zeros(n, 1); e(i) = 1;
    J(:, i) = (f(t, y + h*e) - f0)/h;
end

end
