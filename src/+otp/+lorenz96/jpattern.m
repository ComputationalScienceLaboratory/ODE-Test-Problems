function Jp = jpattern(N)

Jp = spdiags(ones(N, 7), [-(N-1), -2, -1, 0, 1, N-2, N-1], N, N);

end
