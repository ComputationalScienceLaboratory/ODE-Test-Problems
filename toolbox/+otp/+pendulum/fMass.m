function dy = fMass(~, y, lengths, cumulativeMasses, g, scaledMasses)
n = numel(lengths);
angles = y(1:n);
velocities = y(n+1: end);

accelerations = -cumulativeMasses .* g .* lengths .* sin(angles) ...
    -(scaledMasses .* sin(angles - angles.')) * velocities.^2;

dy = [velocities; accelerations];
end
