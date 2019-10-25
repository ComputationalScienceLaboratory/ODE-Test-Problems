function dpsit = f(psi, L, RdnL, PdnL, Ddx, Ddy, ymat, Re, Ro)

% Calculate the vorticity
q = -L*psi;

% calculate Arakawa
dpsix = Ddx*psi;
dpsiy = Ddy*psi;

dqx = Ddx*q;
dqy = Ddy*q;

J1 = dpsix.*dqy     - dpsiy.*dqx;
J2 = Ddx*(psi.*dqy) - Ddy*(psi.*dqx);
J3 = Ddy*(q.*dpsix) - Ddx*(q.*dpsiy);

J = -(J1 + J2 + J3)/3;

% forcing term
F = sin(pi*(ymat - 1));

% vorticity form of the rhs
dqt = -J + (1/Ro)*(Ddx*psi) + (1/Re)*(L*q) + (1/Ro)*F;

% solve into stream form of the rhs
dpsit = PdnL*(RdnL\(RdnL'\(PdnL'*dqt)));

end
