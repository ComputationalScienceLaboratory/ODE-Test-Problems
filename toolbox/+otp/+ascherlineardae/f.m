function dy = f(t, y, beta)

dy = [-1, 1 + t; beta, -1 - beta * t] * y + [0; sin(t)];

end
