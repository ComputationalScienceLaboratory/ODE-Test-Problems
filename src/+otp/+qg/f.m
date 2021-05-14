function dpsit = f(psi, Lx, Ly, P1, P1T, P2, P2T, L12, Dx, DyT, F, Re, Ro)

[nx, ny] = size(L12);

psi = reshape(psi, nx, ny);

% Calculate the vorticity
q = -(Lx*psi + psi*Ly);

% calculate Arakawa
dpsix = Dx*psi;
dpsiy = psi*DyT;

dqx = Dx*q;
dqy = q*DyT;

J1 = dpsix.*dqy     - dpsiy.*dqx;
J2 = Dx*(psi.*dqy) - (psi.*dqx)*DyT;
J3 = (q.*dpsix)*DyT - Dx*(q.*dpsiy);

mJ = (J1 + J2 + J3)/3;

% almost vorticity form of the rhs
dqtmq = mJ + (1/Ro)*(dpsix) + (1/Ro)*F;

% solve the sylvester equation
nLidqtmq = P1*(L12.*(P1T*dqtmq*P2))*P2T;

% solve into stream form of the rhs
dpsit = reshape(nLidqtmq - (1/Re)*(q), nx*ny, 1);

end
