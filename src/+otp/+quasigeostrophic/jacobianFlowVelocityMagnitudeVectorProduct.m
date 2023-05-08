function J = jacobianFlowVelocityMagnitudeVectorProduct(psi, v, Dx, Dy)

nx = size(Dx, 1);
ny = size(Dy, 1);

N = size(v, 2);

psi = repmat(psi, 1, N);

dpsix = reshape(Dx*reshape(psi, nx, []), nx, ny, []);
dpsiy = permute(reshape(Dy*reshape(permute(reshape(psi, nx, ny, []), [2, 1, 3]), ny, []), ny, nx, []), [2, 1, 3]);

dvx = reshape(Dx*reshape(v, nx, []), nx, ny, []);
dvy = permute(reshape(Dy*reshape(permute(reshape(v, nx, ny, []), [2, 1, 3]), ny, []), ny, nx, []), [2, 1, 3]);

m = sqrt((dpsix).^2 + (dpsiy).^2);

J = reshape((1./m).*(dpsix.*(dvx) + dpsiy.*(dvy)), nx*ny, []);

end
