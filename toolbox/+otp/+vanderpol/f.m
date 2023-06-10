function dy = f(~, y, epsilon)

y1 = y(1, :);
y2 = y(2, :);
dy = [y2; ((1 - y1.^2).*y2 - y1)/epsilon];

end
