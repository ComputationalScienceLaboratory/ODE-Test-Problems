function d = distanceFunction(~, y, i, j)

N = numel(y);

d = min([abs(i - j); abs(N + i - j); abs(N + j - i)]);

end
