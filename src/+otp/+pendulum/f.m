function dy = f(~, y, lengths, cumulativeMasses, g)
n = numel(lengths);
angles = y(1:n);
velocities = y(n+1: end);
accelerations = -cumulativeMasses .* g .* lengths .* sin(angles) - sin(angles - angles.') * velocities.^2;

dy = [
    velocities;
    accelerations
    ];
end
