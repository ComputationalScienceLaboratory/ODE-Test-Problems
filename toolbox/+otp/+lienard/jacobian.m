function J = jacobian(~, y, f, df, ~, dg, ~, ~)

y1 = y(1);
y2 = y(2);
J = [0, 1; -dg(y1) - df(y1)*y2, -f(y1)];

end
