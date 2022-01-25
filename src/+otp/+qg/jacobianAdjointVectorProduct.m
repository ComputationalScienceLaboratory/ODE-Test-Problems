function javp = jacobianAdjointVectorProduct(psi, v, Lx, Ly, P1, P2, L12, Dx, DxT, Dy, DyT, ~, Re, Ro)

[nx, ny] = size(L12);

psi = reshape(psi, nx, ny, []);
v   = reshape(v,   nx, ny, []);

% Calculate the vorticity
q = -(pagemtimes(Lx, psi) + pagemtimes(psi, Ly));

dpsix = pagemtimes(Dx, psi);
dpsiy = pagemtimes(psi, DyT);

dqx = pagemtimes(Dx, q);
dqy = pagemtimes(q, DyT);

% solve the sylvester equation
dnLv = pagemtimes(pagemtimes(P1, L12.*pagemtimes(pagemtimes(P1, v), P2)), P2);

dnLvxa = pagemtimes(DxT, dnLv);
dnLvya = pagemtimes(dnLv, Dy);

ddpsixdnLvya = pagemtimes(dpsix.*dnLv, Dy);
ddpsiydnLvxa = pagemtimes(DxT, dpsiy.*dnLv);

psiDxadnLvDy = pagemtimes(psi.*dnLvxa, Dy);
DxTpsiDyadnLv = pagemtimes(DxT, psi.*dnLvya);

dpsixDyadnLv = dpsix.*dnLvya;
dpsiyDxadnLv = dpsiy.*dnLvxa;


% Arakawa approximation
dJpsi1v = -(pagemtimes(Lx, ddpsixdnLvya) + pagemtimes(ddpsixdnLvya, Ly)) + pagemtimes(DxT, dqy.*dnLv) ...
    + (pagemtimes(Lx, ddpsiydnLvxa) + pagemtimes(ddpsiydnLvxa, Ly))      - pagemtimes(dqx.*dnLv, Dy);

dJpsi2v = -(pagemtimes(Lx, psiDxadnLvDy) + pagemtimes(psiDxadnLvDy, Ly)) + dqy.*dnLvxa ...
    + (pagemtimes(Lx, DxTpsiDyadnLv) + pagemtimes(DxTpsiDyadnLv, Ly))    - dqx.*dnLvya;

dJpsi3v = -(pagemtimes(Lx, dpsixDyadnLv) + pagemtimes(dpsixDyadnLv, Ly)) + pagemtimes(DxT, q.*dnLvya) ...
    + (pagemtimes(Lx, dpsiyDxadnLv) + pagemtimes(dpsiyDxadnLv, Ly))      - pagemtimes(q.*dnLvxa, Dy);


dJpsiv = -(dJpsi1v + dJpsi2v + dJpsi3v)/3;

nLv = -(pagemtimes(Lx, v) + pagemtimes(v, Ly));

ddqtpsiav = -dJpsiv + (1/Ro)*dnLvxa  - (1/Re)*(nLv);

javp = reshape(ddqtpsiav, nx*ny, []);

end
