function [W, dWdl, dWdp] = qsplineinterp(lambda1, phi1, lambda2, phi2, r)

phi2T = phi2.';
dell = lambda2.' - lambda1;

cosphi1cosdell = cos(phi1).*cos(dell);

nom = sqrt(  ( cos(phi1).*sin(dell) ).^2 + ( cos(phi2T).*sin(phi1) - sin(phi2T).*cosphi1cosdell ).^2 );
den = sin(phi2T).*sin(phi1) + cos(phi2T).*cosphi1cosdell;
d = atan2( nom, den );

k = d/r;

I = find(k <= 1);
[Is, Js] = ind2sub(size(k), I);

k = k(I);
k2 = k.*k;
k3 = k.*k2;
k4 = k.*k3;
Wv = 1 - 6*k2 + 8*k3 - 3*k4;

nomdphi = -cos(phi2T(Is)).*sin(phi1(Js).') + sin(phi2T(Is)).*cosphi1cosdell(I);
ddphi = nomdphi./nom(I);

nomdlambda = cos(phi2T(Is)).*cos(phi1(Js).').*sin(dell(I));
ddlambda = nomdlambda./nom(I);

dWdlv =  (ddlambda/r).*(-12*k + 24*k2 - 12*k3 );
dWdlv(isnan(dWdlv)) = 0;

dWdpv = (ddphi/r).*(-12*k + 24*k2 - 12*k3 );
dWdpv(isnan(dWdpv)) = 0;

n = size(d, 1);
m = size(d, 2);
W = sparse(Is, Js, Wv, n, m);
dWdl = sparse(Is, Js, dWdlv, n, m);
dWdp = sparse(Is, Js, dWdpv, n, m);

scale = sum(W, 2);
W = W./scale;
dWdl = dWdl./scale;
dWdp = dWdp./scale;

return;



k2 = k.*k;
k3 = k.*k2;
k4 = k.*k3;

W = 1 - 6*k2 + 8*k3 - 3*k4;
W(isnan(W)) = 0;

nomdphi = -cos(phi2T).*sin(phi1) + sin(phi2T).*cosphi1cosdell;
ddphi = nomdphi./nom;

nomdlambda = cos(phi2T).*cos(phi1).*sin(dell);
ddlambda = nomdlambda./nom;

dWdl =  (ddlambda/r).*(-12*k + 24*(k2) - 12*(k3) );
dWdl(isnan(dWdl)) = 0;

dWdp = (ddphi/r).*(-12*k + 24*(k2) - 12*(k3) );
dWdp(isnan(dWdp)) = 0;

% cutoff point
W(k > 1) = 0;
dWdl(k > 1) = 0;
dWdp(k > 1) = 0;


% scale everything by the weights
scale = sum(W, 2);
W = W./scale;
dWdl = dWdl./scale;
dWdp = dWdp./scale;

% return the sparse versions
W = sparse(W);
dWdl = sparse(dWdl);
dWdp = sparse(dWdp);

end
