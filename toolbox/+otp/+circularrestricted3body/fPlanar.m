function dy = fPlanar(~, y, mu, soft)

x = y(1:2, :);
v = y(3:4, :);

d = sqrt((x(1, :) + mu).^2 + x(2, :).^2 + soft^2);
r = sqrt((x(1, :) - 1 + mu).^2 + x(2, :).^2 + soft^2);

dddx = (x(1, :) + mu)./d;
dddy =  x(2, :)./d;
drdx = (x(1, :) - 1 + mu)./r;
drdy =  x(2, :)./r;

dUdx = x(1, :) - ((1 - mu).*dddx)./(d.^2) - (mu.*drdx)./(r.^2);
dUdy = x(2, :) - ((1 - mu).*dddy)./(d.^2) - (mu.*drdy)./(r.^2);

dx = v;
dv = [2*v(2, :) + dUdx; -2*v(1, :) + dUdy];

dy = [dx; dv];

end
