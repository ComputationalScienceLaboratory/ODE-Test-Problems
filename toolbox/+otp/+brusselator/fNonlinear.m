function dy = fNonlinear(~, y, a, ~)

nonlinearTerm = y(1, :).^2 .* y(2, :);

dy = [
     a + nonlinearTerm;
     -nonlinearTerm
];

end
