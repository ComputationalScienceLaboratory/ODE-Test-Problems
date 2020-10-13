function M = mass(~, y, lengths, cumulativeMasses, ~)
n = numel(lengths);
M22 = zeros(n);
for i = 1 : n
    for j = 1 : n
        M22(i,j) = cumulativeMasses(max(i,j)) * lengths(i) * lengths(j) * cos(y(i) - y(j));
    end
end
M = blkdiag(eye(n), M22);
end


