function J = jacflowvelmagvp(psi, u, Ddx, Ddy)

m = sqrt((Ddx*psi).^2 + (Ddy*psi).^2);

dpsix = Ddx*psi;
dpsiy = Ddy*psi;

J = (1./m).*(dpsix.*(Ddx*u) + dpsiy.*(Ddy*u));

end
