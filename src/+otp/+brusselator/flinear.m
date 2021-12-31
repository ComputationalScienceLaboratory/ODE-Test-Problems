function dy = flinear(~, y, ~, b)

dy = [
    -(1 + b) * y(1, :);
    b * y(1, :)
];

end
