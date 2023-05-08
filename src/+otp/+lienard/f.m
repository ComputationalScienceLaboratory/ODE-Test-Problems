function dy = f(t, y, f, ~, g, ~, p, ~)

y1 = y(1, :);
y2 = y(2, :);
dy = [y2; -g(y1) - f(y1).*y2 + p(t)];

end
