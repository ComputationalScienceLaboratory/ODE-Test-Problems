% See
%   Flyer, Natasha, and Grady B. Wright. 
%   "A radial basis function method for the shallow water equations on a sphere." 
%   Proceedings of the Royal Society A: Mathematical, Physical and Engineering Sciences 465, no. 2106 (2009): 1949-1976.

function dhuvwdt = f(huvw, S, Wdecomp, Bx, By, Bz, f, g, x, y, z)

n = size(huvw, 1)/4;

h = huvw(1:n, :);
u = huvw((n+1):(2*n), :);
v = huvw((2*n+1):(3*n), :);
w = huvw((3*n+1):end, :);

ch = Wdecomp\h;
cu = Wdecomp\u;
cv = Wdecomp\v;
cw = Wdecomp\w;

Bxch = Bx*ch;
Bych = By*ch;
Bzch = Bz*ch;

Bxcu = Bx*cu;
Bycv = By*cv;
Bzcw = Bz*cw;

rhsDx = u.*(Bxcu) + v.*(By*cu) + w.*(Bz*cu) + f.*(y.*w - z.*v) + g*Bxch;
rhsDy = u.*(Bx*cv) + v.*(Bycv) + w.*(Bz*cv) + f.*(z.*u - x.*w) + g*Bych;
rhsDz = u.*(Bx*cw) + v.*(By*cw) + w.*(Bzcw) + f.*(x.*v - y.*u) + g*Bzch;

dudt = -( rhsDx.*(1 - x.^2) + rhsDy.*(-x.*y) + rhsDz.*(-x.*z) );
dvdt = -( rhsDx.*(-x.*y) + rhsDy.*(1 - y.^2) + rhsDz.*(-y.*z) );
dwdt = -( rhsDx.*(-x.*z) + rhsDy.*(-y.*z) + rhsDz.*(1 - z.^2) );

dhdt = -( u.*Bxch + v.*Bych + w.*Bzch + h.*(Bxcu + Bycv + Bzcw) );

% Shepard interpolation for stability
dhdt = S*dhdt;
dudt = S*dudt;
dvdt = S*dvdt;
dwdt = S*dwdt;

dhuvwdt = [dhdt; dudt; dvdt; dwdt];

end

