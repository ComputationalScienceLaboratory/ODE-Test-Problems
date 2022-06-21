function dpsit = f(psi, Lx, Ly, P1, P2, L12, Dx, ~, ~, DyT, F, Re, Ro)
% F Computes the QG right hand side

[nx, ny] = size(L12);

psi = reshape(psi, nx, ny, []);

% Calculate the vorticity
q = -(pagemtimes(Lx, psi) + pagemtimes(psi, Ly));

% calculate Arakawa
dpsix = pagemtimes(Dx, psi);
dpsiy = pagemtimes(psi, DyT);

dqx = pagemtimes(Dx, q);
dqy = pagemtimes(q, DyT);

J1 = dpsix.*dqy                 - dpsiy.*dqx;
J2 = pagemtimes(Dx, (psi.*dqy)) - pagemtimes(psi.*dqx, DyT);
J3 = pagemtimes(q.*dpsix, DyT)  - pagemtimes(Dx, q.*dpsiy);

mJ = (J1 + J2 + J3)/3;

% almost vorticity form of the rhs
dqtmq = mJ + (1/Ro)*(dpsix) + (1/Ro)*F;

% solve the sylvester equation
nLidqtmq = pagemtimes(pagemtimes(P1, L12.*pagemtimes(pagemtimes(P1, dqtmq), P2)), P2);

% solve into stream form of the rhs
dpsit = reshape(nLidqtmq - (1/Re)*(q), nx*ny, []);

end
