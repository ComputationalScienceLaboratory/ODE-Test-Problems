
function dhuvwdt = massenstrophyenergy(huvw, S, Wdecomp, Bx, By, Bz, f, g, x, y, z, a, Wscale)

n = size(huvw, 1)/4;

h = huvw(1:n, :);
u = huvw((n+1):(2*n), :);
v = huvw((2*n+1):(3*n), :);
w = huvw((3*n+1):end, :);

ch = Wdecomp\h;
cu = Wdecomp\u;
cv = Wdecomp\v;
cw = Wdecomp\w;

% mass
H = sum(ch);



%Qinner = (By*(cw - cu) + Bx*(cw + cv) - Bz*(cv + cu) + f);

%lQ = Wdecomp\Qinner;

%Q = sum(lQ);

% Enstropy
%aa = By*cw - Bz*cv;
%bb = Bx*cw - Bz*cu;
%cc = Bx*cv - By*cu + f;
% % % % Zix = By*cw - Bz*cv;
% % % % Ziy = Bx*cw - Bz*cu;
% % % % Ziz = Bx*cv - By*cu + f;
% % % % 
% % % % 
% % % % ZixP = ( Zix.*(1 - x.^2) + Ziy.*(-x.*y)    + Ziz.*(-x.*z) );
% % % % ZiyP = ( Zix.*(-x.*y)    + Ziy.*(1 - y.^2) + Ziz.*(-y.*z) );
% % % % ZizP = ( Zix.*(-x.*z)    + Ziy.*(-y.*z)    + Ziz.*(1 - z.^2) );
% % % % 
% % % % Zinner = (ZixP + ZiyP + ZizP).^2;

Zinner = (By*(cw - cu) + Bx*(cw + cv) - Bz*(cv + cu) + f).^2;

lZ = Wdecomp\(Zinner./h);

Z = sum(lZ);

% Energy
% u2 = u.*u;
% v2 = v.*v;
% z2 = z.*z;
% EixP = ( u2.*(1 - x.^2) + v2.*(-x.*y)    + z2.*(-x.*z) );
% EiyP = ( u2.*(-x.*y)    + v2.*(1 - y.^2) + z2.*(-y.*z) );
% EizP = ( u2.*(-x.*z)    + v2.*(-y.*z)    + z2.*(1 - z.^2) );
% lE = Wdecomp\(0.5*(h.*(EixP + EiyP + EizP) + g*(h.*h)));


%lE = ch.*(0.5*(u.*u + v.*v + w.*w) + g*h);


lE = Wdecomp\(0.5*(h.*(u.*u + v.*v + w.*w) + g*(h.*h)));



E = sum(lE);


%dhuvwdt = [H; Q; Z; E];

dhuvwdt = [H; Z; E];

% dhuvwdt = E;


%dhuvwdt = [H; Z];


end

