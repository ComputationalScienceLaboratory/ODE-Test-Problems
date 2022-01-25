function dpsit = fApproximateDeconvolution(psi, Lx, Ly, P1, P2, L12, Dx, ~, ~, DyT, ~, Re, Ro, adcoeffs, L12filter, Fbar)
% See
%
%  San, O., Staples, A. E., & Iliescu, T. (2013). 
%  Approximate deconvolution large eddy simulation of a stratified two-layer quasigeostrophic ocean model. 
%  Ocean Modelling, 63, 1-20.
%

[nx, ny] = size(L12);

psi = reshape(psi, nx, ny, []);

% Calculate the vorticity
q = -(pagemtimes(Lx, psi) + pagemtimes(psi, Ly));

% apply the filter to the streamfunction and to the vorticity
psibar = pagemtimes(pagemtimes(P1, L12filter.*pagemtimes(pagemtimes(P1, psi), P2)), P2);
qbar   = pagemtimes(pagemtimes(P1, L12filter.*pagemtimes(pagemtimes(P1, q), P2)), P2);

psistar = adcoeffs(1)*psi + adcoeffs(2)*psibar;
qstar   = adcoeffs(1)*q   + adcoeffs(2)*qbar;

psibarn = psibar;
qbarn   = qbar;

for i = 2:(numel(adcoeffs) - 1)
    psibarn = pagemtimes(pagemtimes(P1, L12filter.*pagemtimes(pagemtimes(P1, psibarn), P2)), P2);
    qbarn   = pagemtimes(pagemtimes(P1, L12filter.*pagemtimes(pagemtimes(P1, qbarn), P2)), P2);
    
    psistar = psistar + adcoeffs(i + 1)*psibarn;
    qstar   = qstar   + adcoeffs(i + 1)*qbarn;
end

dpsistarx = pagemtimes(Dx, psistar);
dpsistary = pagemtimes(psistar, DyT);

dqstarx = pagemtimes(Dx, qstar);
dqstary = pagemtimes(qstar, DyT);

Jstar1 = dpsistarx.*dqstary     - dpsistary.*dqstarx;
Jstar2 = pagemtimes(Dx, psistar.*dqstary)  - pagemtimes(psistar.*dqstarx, DyT);
Jstar3 = pagemtimes(qstar.*dpsistarx, DyT) - pagemtimes(Dx, qstar.*dpsistary);

mJstar = (Jstar1 + Jstar2 + Jstar3)/3;

mJbar = pagemtimes(pagemtimes(P1, L12filter.*pagemtimes(pagemtimes(P1, mJstar), P2)), P2);

% vorticity form of the rhs
dqbartmq = mJbar + (1/Ro)*pagemtimes(Dx, psibar) + (1/Ro)*Fbar;

% solve the sylvester equation
nLidqstartmq = pagemtimes(pagemtimes(P1, L12.*pagemtimes(pagemtimes(P1, dqbartmq), P2)), P2);

% solve into stream form of the rhs
dpsit = reshape(nLidqstartmq - (1/Re)*(qbar), nx*ny, []);

end
