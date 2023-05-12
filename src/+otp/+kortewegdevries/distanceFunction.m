function d = distanceFunction(i, j, xdom, N)

xi = reshape(xdom(i), size(i));
xj = reshape(xdom(j), size(j));
d = min(min(abs(xi - xj), abs(N + xi - xj)), abs(N + xj - xi));

end
