function d = fulldistancefunction(~, ~, i, j, N)

d = min([abs(i - j); abs(N + i - j); abs(N + j - i)]);

end
