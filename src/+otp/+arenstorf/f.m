function dy = f(~, y, mu)
%F The right-hand side function for the Arenstorf problem
%
%   See also otp.arenstorf.ArenstorfProblem

muPrime = 1 - mu;

p1 = mu + y(1);
p2 = y(1) - muPrime;

d1 = (p1^2 + y(2)^2)^-1.5;
d2 = (p2^2 + y(2)^2)^-1.5;

dy = [y(3:4); ...
      y(1) + 2 * y(4) - muPrime * d1 * p1 - mu * d2 * p2; ...
      y(2) - 2 * y(3) - (muPrime * d1 + mu * d2) * y(2)];
  
end
