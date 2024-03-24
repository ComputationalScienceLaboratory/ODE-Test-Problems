function dy = f(~, y, a, b)

nonlinearTerm = y(1, :).^2 .* y(2, :);

dy = [
    a - (1 + b) * y(1, :) + nonlinearTerm;
    b * y(1, :) - nonlinearTerm
];

end
