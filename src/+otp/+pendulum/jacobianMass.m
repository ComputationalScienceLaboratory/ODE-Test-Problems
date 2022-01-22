function jac = jacobianMass(~, y, lengths, cumulativeMasses, g, scaledMasses)

n = numel(lengths);
angles = y(1:n);
velocities = y(n+1: end).';
dAccelDVel = -2 * scaledMasses .* velocities .* sin(angles - angles.');
dAccelDAng = scaledMasses .* (velocities.^2) .* cos(angles - angles.');
dAccelDAng = dAccelDAng - diag(sum(dAccelDAng, 2) + cumulativeMasses * g .* lengths .* cos(angles));
jac = [zeros(n), eye(n); dAccelDAng, dAccelDVel];

end
