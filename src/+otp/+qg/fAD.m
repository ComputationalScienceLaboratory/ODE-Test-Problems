function dpsibart = fAD(psi, L, RdnL, RdnLT, PdnL, PdnLT, Ddx, Ddy, Fbar, Re, Ro, filter, passes)

% Calculate the vorticity
q = -(L*psi);

coeffs = arrayfun(@(k) (-1)^(k + 1) * nchoosek(passes + 1, k), ...
    1:(passes + 1));

psibar = filter(psi);
qbar   = filter(q);

psistar = coeffs(1)*psi + coeffs(2)*psibar;
qstar   = coeffs(1)*q   + coeffs(2)*qbar;

psibar2 = psibar;
qbar2   = qbar;

for i = 2:passes
    psibar2 = filter(psibar2);
    qbar2   = filter(qbar2);
    
    psistar = psistar + coeffs(i + 1)*psibar2;
    qstar   = qstar   + coeffs(i + 1)*qbar2;
end

Jstar = otp.qg.arakawa(psistar, L, Ddx, Ddy, qstar);

Jbar = filter(Jstar);

% vorticity form of the rhs
dqbartmq = -Jbar + (1/Ro)*(Ddx*psibar) + (1/Ro)*Fbar;

% solve into stream form of the rhs
dpsibart = PdnL*(RdnL\(RdnLT\(PdnLT*dqbartmq))) - (1/Re)*(qbar);

end
