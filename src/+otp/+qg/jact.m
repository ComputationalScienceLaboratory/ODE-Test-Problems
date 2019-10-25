function ddpsitt = jact(psi, L, RdnL, PdnL, Ddx, Ddy, ymat, Re, Ro)

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

ddpsixt = Ddx*dpsit;
ddpsiyt = Ddy*dpsit;

ddqxt = Ddx*dqt;
ddqyt = Ddy*dqt;

% Arakawa approximation
dJ1t = ddpsixt.*dqy + dpsix.*ddqyt   - ddpsiyt.*dqx - dpsiy.*ddqxt;
dJ2t = Ddx*(dpsit.*dqy + psi.*ddqyt) - Ddy*(dpsit.*dqx + psi.*ddqxt);
dJ3t = Ddy*(dqt.*dpsix + q.*ddpsixt) - Ddx*(dqt.*dpsiy + q.*ddpsiyt);

% pay attention to the sign difference!
dJt = -(dJ1t + dJ2t + dJ3t)/3;

ddqtt = -dJt + (1/Ro)*(Ddx*dpsit) + (1/Re)*(L*dqt);

ddpsitt = PdnL*(RdnL\(RdnL'\(PdnL'*ddqtt)));

end
