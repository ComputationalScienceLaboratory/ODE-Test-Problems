function J = jacobianPlanar(~, y, mu, soft)

x = y(1:2, :);
x = reshape(x, 2, 1, []);
N = size(x, 3);

d = sqrt((x(1, 1, :) + mu).^2 + x(2, 1, :).^2 + soft^2);
r = sqrt((x(1, 1, :) - 1 + mu).^2 + x(2, 1, :).^2 + soft^2);

dddx = (x(1, 1, :) + mu)./d;
dddy =  x(2, 1, :)./d;
drdx = (x(1, 1, :) - 1 + mu)./r;
drdy =  x(2, 1, :)./r;

dddxdx = (1 - dddx.^2)./d;
dddxdy = -(dddx.*x(2, 1, :))./(d.^2);
dddydy =  (1 - dddy.^2)./d;

drdxdx = (1 - drdx.^2)./r;
drdxdy = -(drdx.*x(2, 1, :))./(r.^2);
drdydy = (1 - drdy.^2)./r;

dUdxdx = 1 + (2*(1 - mu)*dddx.^2)./(d.^3) ...
    - ((1 - mu)*dddxdx)./(d.^2) ...
    + (2*mu*drdx.^2)./(r.^3) ...
    - (mu*drdxdx)./(r.^2);
dUdxdy = (2*(1 - mu)*dddx.*dddy)./(d.^3) ...
    - ((1 - mu)*dddxdy)./(d.^2) ...
    + (2*mu*drdx.*drdy)./(r.^3) ...
    - (mu.*drdxdy)./(r.^2);
dUdydy = 1 + (2*(1 - mu)*dddy.^2)./(d.^3) ...
    - ((1 - mu)*dddydy)./(d.^2) ...
    + (2*mu*drdy.^2)./(r.^3) ...
    - (mu*drdydy)./(r.^2);

dxdv = [dUdxdx, dUdxdy; dUdxdy, dUdydy];

J = [zeros(2, 2, N), repmat(eye(2), 1, 1, N); ...
    dxdv, repmat([0, 2; -2, 0], 1, 1, N)];

end
