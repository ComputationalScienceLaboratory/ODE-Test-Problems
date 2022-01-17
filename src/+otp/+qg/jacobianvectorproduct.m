function jvp = jacobianvectorproduct(psi, v, Lx, Ly, P1, P2, L12, Dx, ~, ~, DyT, ~, Re, Ro)

[nx, ny] = size(L12);

psi = reshape(psi, nx, ny);
v   = reshape(v,   nx, ny);

% Calculate the vorticity
q = -(Lx*psi + psi*Ly);

dpsix = Dx*psi;
dpsiy = psi*DyT;

dqx = Dx*q;
dqy = q*DyT;

nLv = -(Lx*v + v*Ly);
Dxv = Dx*v;
Dyv = v*DyT;

DxnLv = Dx*nLv;
DynLv = nLv*DyT;

% Arakawa approximation
dJpsi1v = dpsix.*DynLv     + dqy.*Dxv ...
    - dpsiy.*DxnLv         - dqx.*Dyv;

dJpsi2v = Dx*(psi.*DynLv)  + Dx*(dqy.*v) ...
    - (psi.*DxnLv)*DyT     - (dqx.*v)*DyT;

dJpsi3v = (dpsix.*nLv)*DyT + (q.*Dxv)*DyT ...
    - Dx*(dpsiy.*nLv)      - Dx*(q.*Dyv);

dJpsiv = -(dJpsi1v + dJpsi2v + dJpsi3v)/3;

ddqtpsivp = -dJpsiv + (1/Ro)*Dxv;

% solve the sylvester equation
nLidqtmq = P1*(L12.*(P1*ddqtpsivp*P2))*P2;

% solve into stream form of the Jacobian vp
jvp = reshape(nLidqtmq - (1/Re)*(nLv), nx*ny, 1);

end
