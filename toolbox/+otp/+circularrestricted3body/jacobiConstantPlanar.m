function J = jacobiConstantPlanar(y, mu, soft)

x = y(1:2, :);
v = y(3:4, :);

d = sqrt((x(1, :) + mu).^2 + x(2, :).^2 + soft^2);
r = sqrt((x(1, :) - 1 + mu).^2 + x(2, :).^2 + soft^2);

U = 0.5*(x(1, :).^2 + x(2, :).^2) + (1 - mu)./d + mu./r;

J = 2*U - v(1, :).^2 - v(2, :).^2;

end
