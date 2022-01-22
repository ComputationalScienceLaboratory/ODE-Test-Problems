function Jp = partialDerivativeParameters(~, y, ~, ~, ~)

% This will be the jacobian with respect to sigma, rho, and beta

Jp = diag([y(2) - y(1), y(1), -y(3)]);

end
