function Hvp = hessianVectorProduct(~, ~, u, v, ~, ~, ~)

Hvp = [ ...
    0; ...
    -u(3)*v(1) - u(1)*v(3); ...
    u(2)*v(1) + u(1)*v(2)];

end
