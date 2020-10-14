function M = mass(~, y, lengths, cumulativeMasses, ~)

n = numel(lengths);
angles = y(1:n);
js = 1:n;

M22 = lengths .* cumulativeMasses(max(js, js.')) .* lengths .* cos(angles - angles.');

M = blkdiag(eye(n), M22);

end
