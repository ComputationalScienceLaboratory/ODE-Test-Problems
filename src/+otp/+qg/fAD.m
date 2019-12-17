function dpsit = fAD(psi, L, RdnL, PdnL, Ddx, Ddy, ymat, Re, Ro, filter, passes)

% Calculate the vorticity
q = -L*psi;

coeffs = arrayfun(@(k) (-1)^(k + 1) * nchoosek(passes + 1, k), ...
    1:(passes + 1));

psibar = psi;
qbar   = q;

psistar = coeffs(1)*psi;
qstar   = coeffs(1)*q;

for i = 1:passes
    psibar = filter(psibar);
    qbar   = filter(qbar);
    
    psistar = psistar + coeffs(i + 1)*psibar;
    qstar   = qstar   + coeffs(i + 1)*qbar;
end

Jbar = otp.qg.arakawa(psistar, L, Ddx, Ddy, qstar);
% Jstar = coeffs(1)*Jbar;
% 
% for i = 1:passes
%     Jbar = filter(Jbar);
%     
%     Jstar = Jstar + coeffs(i + 1)*Jbar;
% end

Jstar = filter(Jbar);

% forcing term
F = sin(pi*(ymat - 1));

% vorticity form of the rhs
dqt = -Jstar + (1/Ro)*(Ddx*psi) + (1/Re)*(L*q) + (1/Ro)*F;

% solve into stream form of the rhs
dpsit = PdnL*(RdnL\(RdnL'\(PdnL'*dqt)));

end
