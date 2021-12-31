function dy = f(~, y, a, b)

nonlinearTerm = a * y(1, :).^2 * y(2, :);

dy = [
    1 - (1 + b) * y(1, :) + nonlinearTerm;
    b * y(1, :) - nonlinearTerm
];

end
