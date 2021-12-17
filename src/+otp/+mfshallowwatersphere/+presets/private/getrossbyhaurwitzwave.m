% See
%   Williamson, David L., John B. Drake, James J. Hack, Rüdiger Jakob, and Paul N. Swarztrauber. 
%   "A standard test set for numerical approximations to the shallow water equations in spherical geometry." 
%   Journal of Computational Physics 102, no. 1 (1992): 211-224.
function [h, zonalwind, meridionalwind] = getrossbyhaurwitzwave(x, y, z, Omega, a, g, wavenumber)

if nargin < 7
    wavenumber = 4;
end

omega = 7.848e-6;
K = omega;
h0 = 8.0e3;
R = wavenumber;

% convert from Cartesian to spherical coordinates
theta = atan2(z, sqrt(x.^2 + y.^2));
lambda = atan2(y, x);

zonalwind = a*omega*cos(theta) + a*K*( cos(theta).^(R-1) ).*( R*(sin(theta).^2) - (cos(theta).^2)).*cos(R*lambda);
meridionalwind = -a*K*R*( cos(theta).^(R-1) ).*sin(theta).*sin(R*lambda);

At = (R + 1)*( cos(theta).^2 ) + (2*(R^2) - R - 2) - (2*(R^2))./( cos(theta).^2 );
A = (omega/2)*(2*Omega + omega)*( cos(theta).^2 ) + ((K^2)/4)*( cos(theta).^(2*R) ).*At;

Bt = R^2 + 2*R + 2 - ((R + 1).^2).*( cos(theta).^2 );
B = (2*(Omega + omega)*K)/((R+1)*(R+2)).*( cos(theta).^R ).*Bt;

C = ((K^2)/4)*( cos(theta).^(2*R) ).*( (R+1)*( cos(theta).^2 ) - (R+2));

h = (1/g)*(h0 + (a^2)*( A + B.*cos(R*lambda) + C.*cos(2*R*lambda) ));

end
