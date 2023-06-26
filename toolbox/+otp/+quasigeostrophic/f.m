function dpsit = f(psi, Lx, Ly, P1, P2, L12, Dx, ~, ~, DyT, F, Re, Ro, pmt)
% F Computes the QG right hand side

[nx, ny] = size(L12);

psi = reshape(psi, nx, ny, []);

% Calculate the vorticity
q = -(pmt(Lx, psi) + pmt(psi, Ly));

% calculate Arakawa
dpsix = pmt(Dx, psi);
dpsiy = pmt(psi, DyT);

dqx = pmt(Dx, q);
dqy = pmt(q, DyT);

J1 = dpsix.*dqy                 - dpsiy.*dqx;
J2 = pmt(Dx, (psi.*dqy)) - pmt(psi.*dqx, DyT);
J3 = pmt(q.*dpsix, DyT)  - pmt(Dx, q.*dpsiy);

mJ = (J1 + J2 + J3)/3;

% almost vorticity form of the rhs
dqtmq = mJ + (1/Ro)*(dpsix) + (1/Ro)*F;

% solve the sylvester equation
nLidqtmq = pmt(pmt(P1, L12.*pmt(pmt(P1, dqtmq), P2)), P2);

% solve into stream form of the rhs
dpsit = reshape(nLidqtmq - (1/Re)*(q), nx*ny, []);

end
