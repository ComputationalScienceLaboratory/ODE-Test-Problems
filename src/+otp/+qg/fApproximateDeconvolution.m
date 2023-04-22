function dpsit = fApproximateDeconvolution(psi, Lx, Ly, P1, P2, L12, Dx, ~, ~, DyT, ~, Re, Ro, pmt, adcoeffs, L12filter, Fbar)
% See
%
%  San, O., Staples, A. E., & Iliescu, T. (2013). 
%  Approximate deconvolution large eddy simulation of a stratified two-layer quasigeostrophic ocean model. 
%  Ocean Modelling, 63, 1-20.
%

[nx, ny] = size(L12);

psi = reshape(psi, nx, ny, []);

% Calculate the vorticity
q = -(pmt(Lx, psi) + pmt(psi, Ly));

% apply the filter to the streamfunction and to the vorticity
psibar = pmt(pmt(P1, L12filter.*pmt(pmt(P1, psi), P2)), P2);
qbar   = pmt(pmt(P1, L12filter.*pmt(pmt(P1, q), P2)), P2);

psistar = adcoeffs(1)*psi + adcoeffs(2)*psibar;
qstar   = adcoeffs(1)*q   + adcoeffs(2)*qbar;

psibarn = psibar;
qbarn   = qbar;

for i = 2:(numel(adcoeffs) - 1)
    psibarn = pmt(pmt(P1, L12filter.*pmt(pmt(P1, psibarn), P2)), P2);
    qbarn   = pmt(pmt(P1, L12filter.*pmt(pmt(P1, qbarn), P2)), P2);
    
    psistar = psistar + adcoeffs(i + 1)*psibarn;
    qstar   = qstar   + adcoeffs(i + 1)*qbarn;
end

dpsistarx = pmt(Dx, psistar);
dpsistary = pmt(psistar, DyT);

dqstarx = pmt(Dx, qstar);
dqstary = pmt(qstar, DyT);

Jstar1 = dpsistarx.*dqstary     - dpsistary.*dqstarx;
Jstar2 = pmt(Dx, psistar.*dqstary)  - pmt(psistar.*dqstarx, DyT);
Jstar3 = pmt(qstar.*dpsistarx, DyT) - pmt(Dx, qstar.*dpsistary);

mJstar = (Jstar1 + Jstar2 + Jstar3)/3;

mJbar = pmt(pmt(P1, L12filter.*pmt(pmt(P1, mJstar), P2)), P2);

% vorticity form of the rhs
dqbartmq = mJbar + (1/Ro)*pmt(Dx, psibar) + (1/Ro)*Fbar;

% solve the sylvester equation
nLidqstartmq = pmt(pmt(P1, L12.*pmt(pmt(P1, dqbartmq), P2)), P2);

% solve into stream form of the rhs
dpsit = reshape(nLidqstartmq - (1/Re)*(qbar), nx*ny, []);

end
