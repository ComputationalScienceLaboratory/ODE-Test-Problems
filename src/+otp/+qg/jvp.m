function Jacobianvp = jvp(psi, u, L, RdnL, PdnL, Ddx, Ddy, Re, Ro)

% supporting multiple mat-vecs at the same time
N = size(u, 2);
psi = repmat(psi, 1, N);

dpsix = Ddx*psi;
dpsiy = Ddy*psi;

q   = -L*psi;
dqx = Ddx*q;
dqy = Ddy*q;

nLu   = -L*u;
Ddxu = Ddx*u;
Ddyu = Ddy*u;

DdxnLu = Ddx*nLu;
DdynLu = Ddy*nLu;

% Arakawa approximation
dJpsi1u = dpsix.*DdynLu     + dqy.*Ddxu ...
    - dpsiy.*DdxnLu         - dqx.*Ddyu;

dJpsi2u = Ddx*(psi.*DdynLu) + Ddx*(dqy.*u) ...
    - Ddy*(psi.*DdxnLu)     - Ddy*(dqx.*u);

dJpsi3u = Ddy*(dpsix.*nLu)  + Ddy*(q.*Ddxu) ...
    - Ddx*(dpsiy.*nLu)      - Ddx*(q.*Ddyu);


dJpsiu = -(dJpsi1u + dJpsi2u + dJpsi3u)/3;


ddqtpsivp = -dJpsiu + (1/Ro)*Ddxu + (1/Re)*(L*(nLu));

Jacobianvp = PdnL*(RdnL\(RdnL'\(PdnL'*ddqtpsivp)));

end
