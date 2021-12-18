function d = distfn(~, ~, i, j, theta, lambda)

n = numel(lambda);

i = mod(i - 1, n) + 1;
j = mod(j - 1, n) + 1;

li = lambda(i);
pi = theta(i);

lj = lambda(j);
pj = theta(j);

dell = li - lj;

nom = sqrt(  ( cos(pj).*sin(dell) ).^2 + ( cos(pi).*sin(pj) - sin(pi).*cos(pj).*cos(dell) ).^2 );
den = sin(pi).*sin(pj) + cos(pi).*cos(pj).*cos(dell);
d = atan2( nom, den );

end
