function dpsit = f(psi, L, P1, P1T, P2, P2T, L12, Ddx, Ddy, F, Re, Ro)

% Calculate the vorticity
q = -(L*psi);

% calculate Arakawa
dpsix = Ddx*psi;
dpsiy = Ddy*psi;

dqx = Ddx*q;
dqy = Ddy*q;

J1 = dpsix.*dqy     - dpsiy.*dqx;
J2 = Ddx*(psi.*dqy) - Ddy*(psi.*dqx);
J3 = Ddy*(q.*dpsix) - Ddx*(q.*dpsiy);

mJ = (J1 + J2 + J3)/3;

% almost vorticity form of the rhs
dqtmq = mJ + (1/Ro)*(dpsix) + (1/Ro)*F;

% solve the sylvester equation

[nx, ny] = size(L12);
nLidqtmq = reshape(P1*(L12.*(P1T*reshape(dqtmq, nx, ny)*P2))*P2T, nx*ny, 1);

% solve into stream form of the rhs
dpsit = nLidqtmq - (1/Re)*(q);

end
