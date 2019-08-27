function Jp = jacparams(~, y, ~, ~, ~)

% This will be the jacobian with respect to sigma, rho, and beta

Jp = [ ...
    y(2) - y(1), 0   ,  0   ; ...
    0          , y(1),  0   ; ...
    0          , 0   , -y(3)];

end
