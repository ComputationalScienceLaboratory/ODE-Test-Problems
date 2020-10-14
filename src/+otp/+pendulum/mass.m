function M = mass(~, y, lengths, cumulativeMasses, ~)

n = numel(lengths);

js = repmat(1:n, n, 1);
is = js.';
M22 = cumulativeMasses(max(is, js)) .* lengths(is) .* lengths(js) .* cos(y(is) - y(js));

M = blkdiag(eye(n), M22);

end
