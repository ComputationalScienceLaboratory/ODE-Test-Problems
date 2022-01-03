function javp = jacobianadjointvectorproduct(psi, v, Lx, Ly, P1, P2, L12, Dx, DxT, Dy, DyT, ~, Re, Ro)

[nx, ny] = size(L12);

psi = reshape(psi, nx, ny);
v   = reshape(v,   nx, ny);

% Calculate the vorticity
q = -(Lx*psi + psi*Ly);

dpsix = Dx*psi;
dpsiy = psi*DyT;

dqx = Dx*q;
dqy = q*DyT;

% solve the sylvester equation
dnLv = P1*(L12.*(P1*v*P2))*P2;

DxadnLv = DxT*dnLv;
DyadnLv = dnLv*Dy;

dpsixdnLvDy = (dpsix.*dnLv)*Dy;
DxTdpsiydnLv = DxT*(dpsiy.*dnLv);

psiDxadnLvDy = (psi.*DxadnLv)*Dy;
DxTpsiDyadnLv = DxT*(psi.*DyadnLv);

dpsixDyadnLv = dpsix.*DyadnLv
dpsiyDxadnLv = dpsiy.*DxadnLv;


% Arakawa approximation
dJpsi1v = -(Lx*dpsixdnLvDy + dpsixdnLvDy*Ly)   + DxT*(dqy.*dnLv) ...
    + (Lx*DxTdpsiydnLv + DxTdpsiydnLv*Ly)      - (dqx.*dnLv)*Dy;

dJpsi2v = -(Lx*psiDxadnLvDy + psiDxadnLvDy*Ly) + dqy.*DxadnLv ...
    + (Lx*DxTpsiDyadnLv + DxTpsiDyadnLv*Ly)    - dqx.*DyadnLv;

dJpsi3v = -(Lx*dpsixDyadnLv + dpsixDyadnLv*Ly) + DxT*(q.*DyadnLv) ...
    + (Lx*dpsiyDxadnLv + dpsiyDxadnLv*Ly)      - (q.*DxadnLv)*Dy;


dJpsiv = -(dJpsi1v + dJpsi2v + dJpsi3v)/3;

nLv = -(Lx*v + v*Ly);

ddqtpsiav = -dJpsiv + (1/Ro)*DxadnLv  - (1/Re)*(nLv);

javp = ddqtpsiav; 

end

