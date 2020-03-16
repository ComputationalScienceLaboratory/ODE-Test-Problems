function J = jac(~, y)

y1 = y(1);
y2 = y(2);

J = [ -(- y1^3 + 2*y1*y2^2)/(y2^3*(y1^2/y2^2 - 1)^(3/2)), y1^2/(y2^2*(y1^2/y2^2 - 1)^(3/2));
    - 2*y1*(1/y2^2 - 1) - (2*y1)/(y1^2 + 1)^2, (2*(y1^2 + y2^4))/y2^3];

end
