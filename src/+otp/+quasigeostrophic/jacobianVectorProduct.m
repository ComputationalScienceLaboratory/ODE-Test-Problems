function jvp = jacobianVectorProduct(psi, v, Lx, Ly, P1, P2, L12, Dx, ~, ~, DyT, ~, Re, Ro, pmt)

[nx, ny] = size(L12);

psi = reshape(psi, nx, ny, []);
v   = reshape(v,   nx, ny, []);

% Calculate the vorticity
q = -(pmt(Lx, psi) + pmt(psi, Ly));

dpsix = pmt(Dx, psi);
dpsiy = pmt(psi, DyT);

dqx = pmt(Dx, q);
dqy = pmt(q, DyT);

nLv = -(pmt(Lx, v) + pmt(v, Ly));
dvx = pmt(Dx, v);
dvy =  pmt(v, DyT);

dnLvx = pmt(Dx, nLv);
dnLvy =  pmt(nLv, DyT);

% Arakawa approximation
dJpsi1v = dpsix.*dnLvy                + dqy.*dvx ...
    - dpsiy.*dnLvx                    - dqx.*dvy;

dJpsi2v = pmt(Dx, psi.*dnLvy)  + pmt(Dx, dqy.*v) ...
    - pmt(psi.*dnLvx, DyT)     - pmt(dqx.*v, DyT);

dJpsi3v = pmt(dpsix.*nLv, DyT) + pmt(q.*dvx, DyT) ...
    - pmt(Dx, dpsiy.*nLv)      - pmt(Dx, q.*dvy);

dJpsiv = -(dJpsi1v + dJpsi2v + dJpsi3v)/3;

ddqtpsivp = -dJpsiv + (1/Ro)*dvx;

% solve the sylvester equation
nLidqtmq = pmt(pmt(P1, L12.*pmt(pmt(P1, ddqtpsivp), P2)), P2);

% solve into stream form of the Jacobian vp
jvp = reshape(nLidqtmq - (1/Re)*(nLv), nx*ny, []);

end
