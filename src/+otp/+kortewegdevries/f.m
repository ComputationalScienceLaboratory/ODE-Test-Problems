function dudt = f(t, u, BC, meshBC, A, B, theta, alpha, nu, rho)

uBC = BC(t, meshBC);

dud = otp.utils.pde.gfdm.evalAB(A, B, u.', uBC);

dudx = dud(1, :).';
dudxxx = dud(3, :).';

du2d = otp.utils.pde.gfdm.evalAB(A, B, (u.^2).', uBC);

du2dx = du2d(1, :).';

dudt = alpha*(theta*du2dx + 2*(1 - theta)*(u.*dudx)) + rho*dudx + nu*dudxxx;

end
