function Jac = jacobian(t, u, u0, uIn, ~, uT, gamma)

uLeft = [uIn(t); u(1:end-1)];

mainDiag = 2 * gamma * min(u - uLeft + uT, 0) - 1;
lowerDiag = [gamma * (abs(diff(u) + uT) - abs(u0 + uT - u(1:end-1)) - u(2:end) + u0); 0];
Jac = spdiags([lowerDiag, mainDiag], -1:0, length(u), length(u));

end