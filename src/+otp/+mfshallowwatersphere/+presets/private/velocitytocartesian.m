function [u, v, w] = velocitytocartesian(x, y, z, zonalwind, meridionalwind)

% convert from Cartesian to spherical coordinates
theta = atan2(z, sqrt(x.^2 + y.^2));
lambda = atan2(y, x);

% convert from spherical to Cartesian velocity
u = (-zonalwind.*sin(lambda).*cos(theta) - meridionalwind.*cos(lambda).*sin(theta));
v = (zonalwind.*cos(lambda).*cos(theta) - meridionalwind.*sin(lambda).*sin(theta));
w = (meridionalwind.*cos(theta));

end
