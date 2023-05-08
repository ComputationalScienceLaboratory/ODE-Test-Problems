function j = jacobian(~, y, mu)
%JACOBIAN The Jacobian for the Arenstorf problem
%
%   See also otp.arenstorf.f, otp.arenstorf.ArenstorfProblem

muPrime = 1 - mu;

p1 = mu + y(1);
p2 = y(1) - muPrime;

distSq1 = p1^2 + y(2)^2;
distSq2 = p2^2 + y(2)^2;

d1 = muPrime * distSq1^-1.5;
d2 = mu * distSq2^-1.5;

l1 = 3 * muPrime * distSq1^-2.5;
l2 = 3 * mu * distSq2^-2.5;

offDiag = y(2) * (l1 * p1 + l2 * p2);

j = [0, 0, 1, 0; ...
    0, 0, 0, 1; ...
    1 + l1 * p1^2 - d1 + l2 * p2^2 - d2, offDiag, 0, 2; ...
    offDiag, 1 + y(2)^2 * (l1 + l2) - d1 - d2, -2, 0];

end
