function J = jacobiconstant(y, mu, soft)

x = y(1:3, :);
v = y(4:6, :);

d = sqrt((x(1, :) + mu).^2 + x(2, :).^2 + x(3, :).^2 + soft^2);
r = sqrt((x(1, :) - 1 + mu).^2 + x(2, :).^2 + x(3, :).^2 + soft^2);

U = 0.5*(x(1, :).^2 + x(2, :).^2) + (1 - mu)./d + mu./r;

J = 2*U - v(1, :).^2 - v(2, :).^2 - v(3, :).^2;

end
