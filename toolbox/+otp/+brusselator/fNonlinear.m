function dy = fNonlinear(~, y, a, ~)

nonlinearTerm = a * y(1, :).^2 * y(2, :);

dy = [
     1 + nonlinearTerm;
     -nonlinearTerm
];

end
