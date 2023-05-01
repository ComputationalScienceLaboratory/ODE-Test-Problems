function m = flowVelocityMagnitude(psi, Dx, Dy)

nx = size(Dx, 1);
ny = size(Dy, 1);

Dxpsi = reshape(Dx*reshape(psi, nx, []), nx, ny, []);
Dypsi = permute(reshape(Dy*reshape(permute(reshape(psi, nx, ny, []), [2, 1, 3]), ny, []), ny, nx, []), [2, 1, 3]);

m = reshape(sqrt((Dxpsi).^2 + (Dypsi).^2), nx*ny, []);

end
