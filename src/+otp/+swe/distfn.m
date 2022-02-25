function d = distfn(~, ~, i, j, nl, nm, la, me, a)

lats = [nan; kron(ones(nm - 2, 1), la.'); nan];
mers = [me(1); kron(me(2:end-1).', ones(nl, 1)); me(end)];

sinm1sinm2 = sin(mers(i)).*sin(mers(j).');
cosl1ml2 = cos(lats(i) - lats(j).');
cosl1ml2(isnan(cosl1ml2)) = 1;
cosm1cosm2 = cos(mers(i)).*cos(mers(j).');

d = sqrt(2*(1 - (sinm1sinm2.*cosl1ml2 + cosm1cosm2)));

% Do we want to scale everything by the radius a? or leave it as it is?

% Note that since we store h, u, and v at the grid point, we need to copy
% the distance matrix 3^2 times.
% Technically, we should return this.
% d = kron(ones(3, 3), d);

end
