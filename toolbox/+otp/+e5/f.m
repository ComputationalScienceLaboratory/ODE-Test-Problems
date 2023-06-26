function dy = f(~, y, A, B, C, M)

dy1 = -A * y(1) - B * y(1) * y(3);
dy2 = A * y(1) - M * C * y(2) * y(3);
dy4 = B * y(1) * y(3) - C * y(4);

dy = [dy1; dy2; dy2 - dy4; dy4];

end

