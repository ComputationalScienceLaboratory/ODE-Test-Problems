function dy = f(~, y, mu, soft)

x = y(1:3, :);
v = y(4:6, :);

d = sqrt((x(1, :) + mu).^2 + x(2, :).^2 + x(3, :).^2 + soft^2);
r = sqrt((x(1, :) - 1 + mu).^2 + x(2, :).^2 + x(3, :).^2 + soft^2);

dddx = (x(1, :) + mu)./d;
dddy =  x(2, :)./d;
dddz =  x(3, :)./d;
drdx = (x(1, :) - 1 + mu)./r;
drdy =  x(2, :)./r;
drdz =  x(3, :)./r;

dUdx = x(1, :) - ((1 - mu).*dddx)./(d.^2) - (mu.*drdx)./(r.^2);
dUdy = x(2, :) - ((1 - mu).*dddy)./(d.^2) - (mu.*drdy)./(r.^2);
dUdz =         - ((1 - mu).*dddz)./(d.^2) - (mu.*drdz)./(r.^2);

dx = v;
dv = [2*v(2, :) + dUdx; -2*v(1, :) + dUdy; dUdz];

dy = [dx; dv];

end
