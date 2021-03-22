function dy = f(~, y, lengths, cumulativeMasses, g, offDiagScaling, cDiag)

n = numel(lengths);
angles = y(1:n);
dAngles = diff(angles);
velocities = y(n+1:end);

v = -cumulativeMasses .* g .* lengths .* sin(angles);
offDiag1 = sin(dAngles) .* offDiagScaling;
w = velocities.^2;
w(1:end-1) = w(1:end-1) - offDiag1 .* v(2:end);
w(2:end) = w(2:end) + offDiag1 .* v(1:end-1);

offDiag2 = cos(dAngles) .* offDiagScaling;
C = spdiags([[offDiag2; 0], cDiag, [0; offDiag2]], -1:1, n, n);
u = C \ w;
accel = C * v;
accel(1:end-1) = accel(1:end-1) - offDiag1 .* u(2:end);
accel(2:end) = accel(2:end) + offDiag1 .* u(1:end-1);

dy = [velocities; accel];

end

