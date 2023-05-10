n = 64;

tend = 1;

model = otp.rangangermann.presets.Canonical('Size', n);
sol = ode15s(model.RHS.F, [0, tend], model.Y0, ...
    odeset('Mass', model.RHS.Mass, 'MassSingular','yes', 'RelTol', 1e-3, 'Jacobian', model.RHS.Jacobian));
uv = sol.y(:, end);


xb = linspace(0, 1, n + 2);
yb = linspace(0, 1, n + 2);

[y, x] = meshgrid(xb, yb);

exactu = @(t, x, y) (2*x + y).*sin(t);
exactv = @(t, x, y) (x + 3*y).*cos(t);


for i = 1:numel(sol.x)
    t = sol.x(i);
    uv = sol.y(:, i);
    usmall = uv(1:(end/2));
    vsmall = uv((end/2 + 1):end);

    u = exactu(t, x, y);
    v = exactv(t, x, y);

    u(2:(end - 1), 2:(end - 1)) = reshape(usmall, n, n);
    v(2:(end - 1), 2:(end - 1)) = reshape(vsmall, n, n);

    subplot(1, 2, 1)
    imagesc(u); colorbar;
    subplot(1, 2, 2)
    imagesc(exactu(t, x, y)); colorbar;

    pause(0.01)

    drawnow;



end

f = model.RHS.F;

% Japprox = model.RHS.Jacobian(0, uv);
% 
% J = zeros(2*n^2, 2*n^2);
% h = sqrt(eps);
% 
% for i = 1:numel(uv)
%     e = zeros(2*n^2, 1);
%     e(i) = 1;
% 
%     J(:, i) = (f(0, uv + h*e) - f(0, uv - h*e))/(2*h);
% 
% end
% 
% imagesc(J - Japprox); colorbar
% 
% return


usmall = uv(1:(end/2));
vsmall = uv((end/2 + 1):end);

xsmall = reshape(x(2:(end - 1), 2:(end - 1)), [], 1);
ysmall = reshape(y(2:(end - 1), 2:(end - 1)), [], 1);

exactu = @(t, x, y) (2*x + y).*sin(t);
exactv = @(t, x, y) (x + 3*y).*cos(t);

eu = exactu(tend, xsmall, ysmall);
ev = exactv(tend, xsmall, ysmall);

uerr = norm(eu - usmall)/norm(eu)
verr = norm(ev - vsmall)/norm(ev)


            
