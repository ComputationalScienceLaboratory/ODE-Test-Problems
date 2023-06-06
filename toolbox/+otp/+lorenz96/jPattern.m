function Jp = jPattern(n)

Jp = spdiags(ones(n, 7), [-(n-1), -2, -1, 0, 1, n-2, n-1], n, n);

end
