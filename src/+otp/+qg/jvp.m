function jvp = jvp(psi, v, Lx, Ly, P1, P2, L12, Dx, DyT, ~, Re, Ro)

[nx, ny] = size(L12);

psi = reshape(psi, nx, ny);
v   = reshape(v,   nx, ny);

% Calculate the vorticity
q = -(Lx*psi + psi*Ly);

dpsix = Dx*psi;
dpsiy = psi*DyT;

dqx = Dx*q;
dqy = q*DyT;

nLu = -(Lx*v + v*Ly);
Dxu = Dx*v;
Dyu = v*DyT;

DxnLu = Dx*nLu;
DynLu = nLu*DyT;

% Arakawa approximation
dJpsi1u = dpsix.*DynLu     + dqy.*Dxu ...
    - dpsiy.*DxnLu         - dqx.*Dyu;

dJpsi2u = Dx*(psi.*DynLu)  + Dx*(dqy.*v) ...
    - (psi.*DxnLu)*DyT     - (dqx.*v)*DyT;

dJpsi3u = (dpsix.*nLu)*DyT + (q.*Dxu)*DyT ...
    - Dx*(dpsiy.*nLu)      - Dx*(q.*Dyu);

dJpsiu = -(dJpsi1u + dJpsi2u + dJpsi3u)/3;

ddqtpsivp = -dJpsiu + (1/Ro)*Dxu;

% solve the sylvester equation
nLidqtmq = P1*(L12.*(P1*ddqtpsivp*P2))*P2;

% solve into stream form of the Jacobian vp
jvp = reshape(nLidqtmq - (1/Re)*(nLu), nx*ny, 1);

end
