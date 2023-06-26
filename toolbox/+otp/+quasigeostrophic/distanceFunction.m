function d = distanceFunction(~, ~, i, j, nx, ny)

[ix, iy] = ind2sub([nx, ny], i);

[jx, jy] = ind2sub([nx, ny], j);

dx = abs(ix - jx);
dy = abs(iy - jy);

d = sqrt(dx.^2 + dy.^2);

end
