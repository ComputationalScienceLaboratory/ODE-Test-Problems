function dy = f(~, y, mu, soft)

x = y(1:3, :);
v = y(4:6, :);

d = sqrt((x(1, :) + mu).^2 + x(2, :)^2 + x(3, :)^2 + soft^2);
r = sqrt((x(1, :) - 1 + mu).^2 + x(2, :).^2 + x(3, :)^2 + soft^2);
cd = (1 - mu)./d.^3;
cr = mu./r.^3;

dx       = v;
dv       = [...
     2*v(2, :) + (1 - cd - cr).*x(1, :) - (cd + cr).*mu + cr; ...
    -2*v(1, :) + (1 - cd - cr).*x(2, :); ...
    -(cd + cr).*x(3, :)];

dy = [dx; dv];

end
