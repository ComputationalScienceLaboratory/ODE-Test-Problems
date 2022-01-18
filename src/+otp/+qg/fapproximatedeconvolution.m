function dpsit = fapproximatedeconvolution(psi, Lx, Ly, P1, P2, L12, Dx, ~, ~, DyT, ~, Re, Ro, adcoeffs, L12filter, Fbar)
% See
%
%  San, O., Staples, A. E., & Iliescu, T. (2013). 
%  Approximate deconvolution large eddy simulation of a stratified two-layer quasigeostrophic ocean model. 
%  Ocean Modelling, 63, 1-20.
%

[nx, ny] = size(L12);

psi = reshape(psi, nx, ny);

% Calculate the vorticity
q = -(Lx*psi + psi*Ly);

% apply the filter to the streamfunction and to the vorticity
psibar = P1*(L12filter.*(P1*psi*P2))*P2;
qbar   = P1*(L12filter.*(P1*q*P2))*P2;

psistar = adcoeffs(1)*psi + adcoeffs(2)*psibar;
qstar   = adcoeffs(1)*q   + adcoeffs(2)*qbar;

psibarn = psibar;
qbarn   = qbar;

for i = 2:(numel(adcoeffs) - 1)
    psibarn = P1*(L12filter.*(P1*psibarn*P2))*P2;
    qbarn   = P1*(L12filter.*(P1*qbarn*P2))*P2;
    
    psistar = psistar + adcoeffs(i + 1)*psibarn;
    qstar   = qstar   + adcoeffs(i + 1)*qbarn;
end

dpsistarx = Dx*psistar;
dpsistary = psistar*DyT;

dqstarx = Dx*qstar;
dqstary = qstar*DyT;

Jstar1 = dpsistarx.*dqstary     - dpsistary.*dqstarx;
Jstar2 = Dx*(psistar.*dqstary)  - (psistar.*dqstarx)*DyT;
Jstar3 = (qstar.*dpsistarx)*DyT - Dx*(qstar.*dpsistary);

mJstar = (Jstar1 + Jstar2 + Jstar3)/3;

mJbar = P1*(L12filter.*(P1*mJstar*P2))*P2;

% vorticity form of the rhs
dqbartmq = mJbar + (1/Ro)*(Dx*psibar) + (1/Ro)*Fbar;

% solve the sylvester equation
nLidqstartmq = P1*(L12.*(P1*dqbartmq*P2))*P2;

% solve into stream form of the rhs
dpsit = reshape(nLidqstartmq - (1/Re)*(qbar), nx*ny, 1);

end
