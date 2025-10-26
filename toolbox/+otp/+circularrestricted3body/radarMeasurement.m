function rmeas = radarMeasurement(~, y, ~, ~, radary)

x = y(1:3, :);
v = y(4:6, :);

relpos = x - radary;

r = sqrt(relpos(1, :).^2 + relpos(2, :).^2 + relpos(3, :).^2);
drdt = sum(relpos.*v, 1)/r;
theta = atan2(relpos(2, :), relpos(1, :));
phi = atan2(relpos(3, :), r);


rmeas = [r; drdt; theta; phi];

end
