function J = jacobian(~, y, f, q, s, w)

y1 = y(1);
y2 = y(2);

J = [ ...
    s * (1 - y2 - q * y1), s * (1 - y1), 0; ...
    -y2 / s, -(1 + y1) / s, f / s; ...
    w, 0, -w];

end
