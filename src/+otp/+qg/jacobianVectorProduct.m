function jvp = jacobianVectorProduct(psi, v, Lx, Ly, P1, P2, L12, Dx, ~, ~, DyT, ~, Re, Ro)

[nx, ny] = size(L12);

psi = reshape(psi, nx, ny, []);
v   = reshape(v,   nx, ny, []);

% Calculate the vorticity
q = -(pagemtimes(Lx, psi) + pagemtimes(psi, Ly));

dpsix = pagemtimes(Dx, psi);
dpsiy = pagemtimes(psi, DyT);

dqx = pagemtimes(Dx, q);
dqy = pagemtimes(q, DyT);

nLv = -(pagemtimes(Lx, v) + pagemtimes(v, Ly));
dvx = pagemtimes(Dx, v);
dvy =  pagemtimes(v, DyT);

dnLvx = pagemtimes(Dx, nLv);
dnLvy =  pagemtimes(nLv, DyT);

% Arakawa approximation
dJpsi1v = dpsix.*dnLvy                + dqy.*dvx ...
    - dpsiy.*dnLvx                    - dqx.*dvy;

dJpsi2v = pagemtimes(Dx, psi.*dnLvy)  + pagemtimes(Dx, dqy.*v) ...
    - pagemtimes(psi.*dnLvx, DyT)     - pagemtimes(dqx.*v, DyT);

dJpsi3v = pagemtimes(dpsix.*nLv, DyT) + pagemtimes(q.*dvx, DyT) ...
    - pagemtimes(Dx, dpsiy.*nLv)      - pagemtimes(Dx, q.*dvy);

dJpsiv = -(dJpsi1v + dJpsi2v + dJpsi3v)/3;

ddqtpsivp = -dJpsiv + (1/Ro)*dvx;

% solve the sylvester equation
nLidqtmq = pagemtimes(pagemtimes(P1, L12.*pagemtimes(pagemtimes(P1, ddqtpsivp), P2)), P2);

% solve into stream form of the Jacobian vp
jvp = reshape(nLidqtmq - (1/Re)*(nLv), nx*ny, []);

end
