function dy = f(~, y, f, q, s, w)

y1 = y(1, :);
y2 = y(2, :);
y3 = y(3, :);

dy = [ ...
    s * (y2 + y1 .* (1 - q * y1 - y2)); ...
    (f * y3 - (1 + y1) .* y2) / s; ...
    w * (y1 - y3)];

end
