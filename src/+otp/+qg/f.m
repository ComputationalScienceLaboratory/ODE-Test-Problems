function dpsit = f(psi, L, RdnL, RdnLT, PdnL, PdnLT, Ddx, Ddy, F, Re, Ro)

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

% solve into stream form of the rhs
dpsit = PdnL*(RdnL\(RdnLT\(PdnLT*dqtmq))) - (1/Re)*(q);

end
