function c = invariant(t, u, BC, meshBC, A, B, ~, alpha, nu, rho, volume)

c = zeros(3, size(u, 2));

c(1, :) = volume*mean(u, 1);
c(2, :) = volume*mean(u.^2, 1);

uBC = BC(t, meshBC);
dud = otp.utils.pde.gfdm.evalAB(A, B, u.', uBC);
dudx = dud(1, :).';

c(3, :) = volume*mean((alpha/3)*(u.^3) + (rho/2)*(u.^2) - (nu/2)*(dudx.^2), 1);

end
