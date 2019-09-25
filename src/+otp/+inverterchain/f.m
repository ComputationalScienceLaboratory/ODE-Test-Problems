function uPrime = f(t, u, u0, uIn, uOp, uT, gamma)

uLeft = [uIn(t); u(1:end-1)];

uPrime = uOp - u + gamma * (max(uLeft - u - uT, 0).^2 - max(uLeft - u0 - uT, 0).^2);

end