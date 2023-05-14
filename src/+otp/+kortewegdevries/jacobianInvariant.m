function DI = jacobianInvariant(u, alpha, nu, rho, nx, Dxf, dx)
DI = dx*[ones(1, nx); ...
    2*u.'; ...
    (alpha*(u.^2) ...
    + rho*u ...
    - nu*(Dxf.'*(Dxf*u))).'];
end