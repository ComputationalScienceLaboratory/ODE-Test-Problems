function dy = f(~, y, lengths, cumulativeMasses, g, offDiagScaling, cDiag)

n = numel(lengths);
angles = y(1:n);
dAngles = angles(2:end) - angles(1:end-1);
velocities = y(n+1:end);

% Following the optimizations and notation of page 10 of
% "Solving Ordinary Differential Equations II: Stiff and Differential-Algebraic Problems"

v = -cumulativeMasses .* g .* lengths .* sin(angles);
offDiag1 = sin(dAngles) .* offDiagScaling;
w = velocities.^2;
w(1:end-1) = w(1:end-1) - offDiag1 .* v(2:end);
w(2:end) = w(2:end) + offDiag1 .* v(1:end-1);

offDiag2 = cos(dAngles) .* offDiagScaling;
C = spdiags([[offDiag2; 0], cDiag, [0; offDiag2]], -1:1, n, n);
u = C \ w;
accelerations = C * v;
accelerations(1:end-1) = accelerations(1:end-1) - offDiag1 .* u(2:end);
accelerations(2:end) = accelerations(2:end) + offDiag1 .* u(1:end-1);

dy = [velocities; accelerations];

end
