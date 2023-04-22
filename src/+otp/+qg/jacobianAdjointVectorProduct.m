function javp = jacobianAdjointVectorProduct(psi, v, Lx, Ly, P1, P2, L12, Dx, DxT, Dy, DyT, ~, Re, Ro, pmt)

[nx, ny] = size(L12);

psi = reshape(psi, nx, ny, []);
v   = reshape(v,   nx, ny, []);

% Calculate the vorticity
q = -(pmt(Lx, psi) + pmt(psi, Ly));

dpsix = pmt(Dx, psi);
dpsiy = pmt(psi, DyT);

dqx = pmt(Dx, q);
dqy = pmt(q, DyT);

% solve the sylvester equation
dnLv = pmt(pmt(P1, L12.*pmt(pmt(P1, v), P2)), P2);

dnLvxa = pmt(DxT, dnLv);
dnLvya = pmt(dnLv, Dy);

ddpsixdnLvya = pmt(dpsix.*dnLv, Dy);
ddpsiydnLvxa = pmt(DxT, dpsiy.*dnLv);

psiDxadnLvDy = pmt(psi.*dnLvxa, Dy);
DxTpsiDyadnLv = pmt(DxT, psi.*dnLvya);

dpsixDyadnLv = dpsix.*dnLvya;
dpsiyDxadnLv = dpsiy.*dnLvxa;


% Arakawa approximation
dJpsi1v = -(pmt(Lx, ddpsixdnLvya) + pmt(ddpsixdnLvya, Ly)) + pmt(DxT, dqy.*dnLv) ...
    + (pmt(Lx, ddpsiydnLvxa) + pmt(ddpsiydnLvxa, Ly))      - pmt(dqx.*dnLv, Dy);

dJpsi2v = -(pmt(Lx, psiDxadnLvDy) + pmt(psiDxadnLvDy, Ly)) + dqy.*dnLvxa ...
    + (pmt(Lx, DxTpsiDyadnLv) + pmt(DxTpsiDyadnLv, Ly))    - dqx.*dnLvya;

dJpsi3v = -(pmt(Lx, dpsixDyadnLv) + pmt(dpsixDyadnLv, Ly)) + pmt(DxT, q.*dnLvya) ...
    + (pmt(Lx, dpsiyDxadnLv) + pmt(dpsiyDxadnLv, Ly))      - pmt(q.*dnLvxa, Dy);


dJpsiv = -(dJpsi1v + dJpsi2v + dJpsi3v)/3;

nLv = -(pmt(Lx, v) + pmt(v, Ly));

ddqtpsiav = -dJpsiv + (1/Ro)*dnLvxa  - (1/Re)*(nLv);

javp = reshape(ddqtpsiav, nx*ny, []);

end
