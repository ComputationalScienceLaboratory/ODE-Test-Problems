function J = arakawa(psi, L, Ddx, Ddy)
% Computes the Arakawa approximation of order 2

dpsix = Ddx*psi;
dpsiy = Ddy*psi;

q   = -L*psi;
dqx = Ddx*q;
dqy = Ddy*q;

% Arakawa approximation
J1 = dpsix.*dqy     - dpsiy.*dqx;
J2 = Ddx*(psi.*dqy) - Ddy*(psi.*dqx);
J3 = Ddy*(q.*dpsix) - Ddx*(q.*dpsiy);

% pay attention to the sign difference!
J = -(J1 + J2 + J3)/3;

end
