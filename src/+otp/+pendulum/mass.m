function M = mass(~, y, lengths, ~, ~, scaledMasses)

n = numel(lengths);
angles = y(1:n);

M22 = scaledMasses .* cos(angles - angles.');

M = blkdiag(eye(n), M22);

end
