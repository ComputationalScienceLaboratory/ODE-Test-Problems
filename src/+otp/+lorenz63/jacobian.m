function J = jacobian(~, y, sigma, rho, beta)

J = [ ...
    -sigma  ,  sigma,  0   ; ...
    rho-y(3), -1    , -y(1); ...
    y(2)    ,  y(1) , -beta];

end