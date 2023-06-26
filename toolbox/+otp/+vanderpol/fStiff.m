function dy = fStiff(~, y, epsilon)

y1 = y(1, :);
y2 = y(2, :);
dy = [zeros(1, size(y, 2)); ((1 - y1.^2).*y2 - y1)/epsilon];

end
