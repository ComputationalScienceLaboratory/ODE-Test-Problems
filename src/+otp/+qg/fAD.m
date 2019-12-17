function dpsibart = fAD(psi, L, RdnL, PdnL, Ddx, Ddy, ymat, Re, Ro, filter, passes)

% Calculate the vorticity
q = -L*psi;

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

% forcing term
Fbar = filter(sin(pi*(ymat - 1)));

% vorticity form of the rhs
dqbart = -Jbar + (1/Ro)*(Ddx*psibar) + (1/Re)*(L*qbar) + (1/Ro)*Fbar;

%dqbart = -Jbar + filter((1/Ro)*(Ddx*psi)) + filter((1/Re)*(L*q)) + (1/Ro)*Fbar;


% solve into stream form of the rhs
dpsibart = PdnL*(RdnL\(RdnL'\(PdnL'*dqbart)));

end
