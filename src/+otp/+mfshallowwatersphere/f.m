% See
%   Flyer, Natasha, and Grady B. Wright. 
%   "A radial basis function method for the shallow water equations on a sphere." 
%   Proceedings of the Royal Society A: Mathematical, Physical and Engineering Sciences 465, no. 2106 (2009): 1949-1976.

function dhuvwdt = f(huvw, S, Wdecomp, Bx, By, Bz, Bx2, By2, Bz2, f, g, x, y, z, a, sch0)

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

k = 0;
nu = 1e-1;

rhsDx = u.*(Bxcu) + v.*(By*cu) + w.*(Bz*cu) + f.*(y.*w - z.*v) + g*Bxch - k*u + nu*(Bx2*u);
rhsDy = u.*(Bx*cv) + v.*(Bycv) + w.*(Bz*cv) + f.*(z.*u - x.*w) + g*Bych - k*v + nu*(By2*v);
rhsDz = u.*(Bx*cw) + v.*(By*cw) + w.*(Bzcw) + f.*(x.*v - y.*u) + g*Bzch - k*w + nu*(Bz2*w);

dudt = -( rhsDx.*(1 - x.^2) + rhsDy.*(-x.*y) + rhsDz.*(-x.*z) );
dvdt = -( rhsDx.*(-x.*y) + rhsDy.*(1 - y.^2) + rhsDz.*(-y.*z) );
dwdt = -( rhsDx.*(-x.*z) + rhsDy.*(-y.*z) + rhsDz.*(1 - z.^2) );

dhdt = -( u.*Bxch + v.*Bych + w.*Bzch + h.*(Bxcu + Bycv + Bzcw) );



% MASS CORRECTION

% g = sum(ch) - sch0;
% 
% cones = Wdecomp\ones(n, 1);
% 
% J = sum(cones.^2);
% 
% gamma = 1e-1;
% %gamma = 0;
% 
% dhdt = dhdt - gamma*cones*(J\g);

% mass
%mean(h);


%theta = atan2(z, sqrt(x.^2 + y.^2));
%lambda = atan2(y, x);

%m = w./cos(theta);
%z = (v + m.*sin(lambda).*sin(theta))./(cos(lambda).*cos(theta));


% Enstropy
% aa = By*cw - Bz*cv;
% bb = Bx*cw - Bz*cu;
% cc = Bx*cv - By*cu + f;
% 6370000*mean((aa + bb + cc)./h);
% 
% % Energy
% aa = 0.5*(h.*(u.*u + v.*v + w.*w) + g*(h.*h));
% mean(aa);


%mean( (m.^2 + z.^2 + g*h).*h )

%mean( (m.^2 + z.^2 + g*h).*h )



% Shepard interpolation for stability
% dhdt = S*dhdt;
% dudt = S*dudt;
% dvdt = S*dvdt;
% dwdt = S*dwdt;

dhuvwdt = [dhdt; dudt; dvdt; dwdt];

end

