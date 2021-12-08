function [W, dWdl, dWdp] = rbfinterp(lambda1, phi1, lambda2, phi2, r, rbf)

phi2T = phi2.';
dell = lambda2.' - lambda1;

cosphi1cosdell = cos(phi1).*cos(dell);

nom = sqrt(  ( cos(phi1).*sin(dell) ).^2 + ( cos(phi2T).*sin(phi1) - sin(phi2T).*cosphi1cosdell ).^2 );
den = sin(phi2T).*sin(phi1) + cos(phi2T).*cosphi1cosdell;
d = atan2( nom, den );

n = size(d, 1);
m = size(d, 2);

k = d/r;

I = find(k <= 1);
[Is, Js] = ind2sub(size(k), I);

k = k(I);

[Wv, drbfk] = rbf(k);
Wv(isnan(Wv)) = 0;

nomdphi = -cos(phi2T(Is)).*sin(phi1(Js).') + sin(phi2T(Is)).*cosphi1cosdell(I);
ddphi = nomdphi./nom(I);

nomdlambda = cos(phi2T(Is)).*cos(phi1(Js).').*sin(dell(I));
ddlambda = nomdlambda./nom(I);

dWdlv = (ddlambda/r).*drbfk;
dWdlv(isnan(dWdlv)) = 0;

dWdpv = (ddphi/r).*drbfk;
dWdpv(isnan(dWdpv)) = 0;


W = sparse(Is, Js, Wv, n, m);
dWdl = sparse(Is, Js, dWdlv, n, m);
dWdp = sparse(Is, Js, dWdpv, n, m);

scale = sum(W, 2);
W = W./scale;
dWdl = dWdl./scale;
dWdp = dWdp./scale;

end
