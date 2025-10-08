function rmeas = radarMeasurementPlanar(~, y, ~, ~, radary)

x = y(1:2, :);
v = y(3:4, :);

relpos = x - radary;

r = sqrt(relpos(1, :).^2 + relpos(2, :).^2);
drdt = sum(relpos.*v, 1)/r;
theta = atan2(relpos(2, :), relpos(1, :));

rmeas = [r; drdt; theta];

end
