function jx = jacobianAdjointVectorProduct(~, y, x, a, b)

v1 = 2 * y(1, :).*y(2, :);
v2 = y(1, :).^2;

jx = [
    (v1 - b - 1) .* x(1, :) + (b - v1) .* x(2, :);
    v2 .* (x(1, :) - x(2, :))
    ];
end
