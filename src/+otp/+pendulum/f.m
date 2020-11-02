function dy = f(~, y, lengths, cumulativeMasses, g)
n = numel(lengths);
angles = y(1:n);
velocities = y(n+1: end);
js = 1:n;
accelerations = -cumulativeMasses .* g .* lengths .* sin(angles) ...
    -(lengths .* cumulativeMasses(max(js, js.')) .* lengths.' .* sin(angles - angles.')) * velocities.^2;

dy = [
    velocities;
    accelerations
    ];
end
