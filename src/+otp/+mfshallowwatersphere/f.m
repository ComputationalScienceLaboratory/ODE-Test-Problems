function dhuvdt = f(huv, W, dWdl, dWdp, cosphi, tanphi, g, a, f)

% unpack huv into its constituent parts
n = size(huv, 1)/3;

h = huv(1:n);
u = huv((n+1):(2*n));
v = huv((2*n+1):end);

% calculate the derivatives with respect to phi and lambda
dhdl = dWdl*h;
dhdp = dWdp*h;
dudl  = dWdl*u;
dudp  = dWdp*u;
dvdl = dWdl*v;
dvdp = dWdp*v;

% calculate 
dcospvdp = dWdp*(cosphi.*v);

dhdt = -(u./(a*cosphi)).*dhdl - (v/a).*dhdp - (h./(a*cosphi)).*(dudl + dcospvdp);
dudt = -(u./(a*cosphi)).*dudl - (v/a).*dudp - (g./(a*cosphi)).*dhdl + (f + (u/a).*tanphi).*v;
dvdt = -(u./(a*cosphi)).*dvdl - (v/a).*dvdp - (g./a).*dhdp - (f + (u/a).*tanphi).*u;

% Interpolate the derivatives to smooth them out
dhdt = W*dhdt;
dudt = W*dudt;
dvdt = W*dvdt;

dhuvdt = [dhdt; dudt; dvdt];

end
