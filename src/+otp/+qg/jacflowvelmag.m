function J = jacflowvelmag(psi, Ddx, Ddy)

n = numel(psi);

m = sqrt((Ddx*psi).^2 + (Ddy*psi).^2);

dpsix = Ddx*psi;
dpsiy = Ddy*psi;

J = spdiags(1./m, 0, n, n)*(spdiags(dpsix, 0, n, n)*Ddx + spdiags(dpsiy, 0, n, n)*Ddy);

end
