function Jacobianavp = javp(psi, u, L, RdnL, PdnL, Ddx, Ddy, Re, Ro)

% supporting multiple mat-vecs at the same time
N = size(u, 2);
psi = repmat(psi, 1, N);

dpsix = Ddx*psi;
dpsiy = Ddy*psi;

q   = -L*psi;
dqx = Ddx*q;
dqy = Ddy*q;

dnLu = PdnL*(RdnL\(RdnL'\(PdnL'*u)));

DdxadnLu = Ddx'*dnLu;
DdyadnLu = Ddy'*dnLu;

% Arakawa approximation
dJpsi1u = -L*(Ddy'*(dpsix.*dnLu))   + Ddx'*(dqy.*dnLu) ...
    + L*(Ddx'*(dpsiy.*dnLu))       - Ddy'*(dqx.*dnLu);

dJpsi2u = -L*(Ddy'*(psi.*DdxadnLu)) + dqy.*DdxadnLu ...
    + L*(Ddx'*(psi.*DdyadnLu))     - dqx.*DdyadnLu;

dJpsi3u = -L*(dpsix.*DdyadnLu)   + Ddx'*(q.*DdyadnLu) ...
    + L*(dpsiy.*DdxadnLu)       - Ddy'*(q.*DdxadnLu);


dJpsiu = -(dJpsi1u + dJpsi2u + dJpsi3u)/3;

ddqtpsiau = - dJpsiu + (1/Ro)*DdxadnLu  + (1/Re)*(-L'*(L*dnLu));

Jacobianavp = ddqtpsiau; 

end
