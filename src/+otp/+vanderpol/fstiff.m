function dy = fstiff(~, y, epsilon)

y1 = y(1);
y2 = y(2);
dy = [0; ((1 - y1^2) * y2 - y1) / epsilon];

end
