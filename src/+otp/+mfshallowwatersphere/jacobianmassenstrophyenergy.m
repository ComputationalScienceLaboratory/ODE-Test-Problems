
function dhuvwdt = jacobianmassenstrophyenergy(huvw, S, Wdecomp, Bx, By, Bz, f, g, x, y, z, a, Wscale)

n = size(huvw, 1)/4;

h = huvw(1:n, :);
u = huvw((n+1):(2*n), :);
v = huvw((2*n+1):(3*n), :);
w = huvw((3*n+1):end, :);

ch = Wdecomp\h;
cu = Wdecomp\u;
cv = Wdecomp\v;
cw = Wdecomp\w;


cones = Wdecomp\ones(n, 1);

% mass
Hh = cones.';
Hu = zeros(1, n);
Hv = zeros(1, n);
Hw = zeros(1, n);



% vorticity
% % % Qh =  zeros(1, n);
% % % Qu = -(Wdecomp\(Bz.'*cones + By.'*cones)).';
% % % Qv = (Wdecomp\(Bx.'*cones - Bz.'*cones)).';
% % % Qw = (Wdecomp\(By.'*cones + Bx.'*cones)).';


% Enstropy

Zinner = (By*(cw - cu) + Bx*(cw + cv) - Bz*(cv + cu) + f);


t0 = cones.*(Zinner./h);

Zh =  -(cones.*(((Zinner.^2)./(h.^2)))).';

Zu = -2*(Wdecomp\(Bz.'*t0 + By.'*t0)).';
Zv = 2*(Wdecomp\(Bx.'*t0 - Bz.'*t0)).';
Zw = 2*(Wdecomp\(By.'*t0 + Bx.'*t0)).';


% % % Zix = By*cw - Bz*cv;
% % % Ziy = Bx*cw - Bz*cu;
% % % Ziz = Bx*cv - By*cu + f;
% % % ZixP = ( Zix.*(1 - x.^2) + Ziy.*(-x.*y)    + Ziz.*(-x.*z) );
% % % ZiyP = ( Zix.*(-x.*y)    + Ziy.*(1 - y.^2) + Ziz.*(-y.*z) );
% % % ZizP = ( Zix.*(-x.*z)    + Ziy.*(-y.*z)    + Ziz.*(1 - z.^2) );
% % % Zinner = (ZixP + ZiyP + ZizP);
% % % 
% % % 
% % % coZihi = (cones.*Zinner)./h;
% % % 
% % % Zh =  -(cones.*(((Zinner.^2)./(h.^2)))).';
% % % Zu = -2*(Wdecomp\( ...
% % %     By.'*(coZihi.*(1 - z.^2 - x.*z - y.*z)) ...
% % %     + Bz.'*(coZihi.*(1 - y.^2 - x.*y - y.*z)) ...
% % %     )).';
% % % Zv = 2*(Wdecomp\( ...
% % %     Bx.'*(coZihi.*(1 - z.^2 - x.*z - y.*z)) ...
% % %     - Bz.'*(coZihi.*(1 - x.^2 - x.*y - x.*z)) ...
% % %     )).';
% % % Zw = 2*(Wdecomp\( ...
% % %     Bx.'*(coZihi.*(1 - y.^2 - x.*y - y.*z)) ...
% % %     + By.'*(coZihi.*(1 - x.^2 - x.*y - x.*z)) ...
% % %     )).';


% Zh =
% Zu = -(Wdecomp\(Bz.'*(cones./h) + By.'*(cones./h))).';
% Zv = (Wdecomp\(Bx.'*(cones./h) - Bz.'*(cones./h))).';
% Zw = (Wdecomp\(By.'*(cones./h) + Bx.'*(cones./h))).';


%Eh =  (0.5*((u.*u + v.*v + w.*w) + 2*g*h)).'/n;

Eh =  (cones.*(0.5*((u.*u + v.*v + w.*w) + 2*g*h))).';
Eu = (cones.*(h.*u)).';
Ev = (cones.*(h.*v)).';
Ew = (cones.*(h.*w)).';



% Eh = (g*ch + Wdecomp\(0.5*(u.*u + v.*v + w.*w) + g*h)).';
% Eu = (ch.*u).';
% Ev = (ch.*v).';
% Ew = (ch.*w).';




%dhuvwdt = [Hh, Hu, Hv, Hw; Qh, Qu, Qv, Qw; Zh, Zu, Zv, Zw; Eh, Eu, Ev,Ew];

%dhuvwdt = [Hh, Hu, Hv, Hw];

%dhuvwdt = [Zh, Zu, Zv, Zw];

% dhuvwdt = [Eh, Eu, Ev, Ew];

%dhuvwdt = [Hh, Hu, Hv, Hw; Eh, Eu, Ev, Ew];

dhuvwdt = [Hh, Hu, Hv, Hw; Zh, Zu, Zv, Zw; Eh, Eu, Ev, Ew];

end

