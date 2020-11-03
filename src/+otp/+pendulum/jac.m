function jac = jac(~, y, lengths, cumulativeMasses, g, scaledMasses)
n = numel(lengths);
angles = y(1:n);
velocities = y(n+1: end).';
dadv = -2 * scaledMasses .* velocities .* sin(angles - angles.');
dada1 = scaledMasses .* (velocities.^2) .* cos(angles - angles.');
dada1 = dada1 - diag(diag(dada1));
dada1 = dada1 - diag(sum(dada1,2));
dada = dada1 + diag(cumulativeMasses * -g .* lengths .* cos(angles));
jac = [
    zeros(n), eye(n);
    dada, dadv
    ];

end


