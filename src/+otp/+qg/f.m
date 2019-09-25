function dpsit = f(psi, L, RdnL, PdnL, Ddx, Ddy, ymat, Re, Ro)

% Calculate the vorticity
q = -L*psi;

% calculate Arakawa
J = otp.qg.arakawa(psi, L, Ddx, Ddy);

% forcing term
F = sin(pi*(ymat - 1));

% vorticity form of the rhs
dqt = -J + (1/Ro)*(Ddx*psi) + (1/Re)*(L*q) + (1/Ro)*F;

% solve into stream form of the rhs
dpsit = PdnL*(RdnL\(RdnL'\(PdnL'*dqt)));

end