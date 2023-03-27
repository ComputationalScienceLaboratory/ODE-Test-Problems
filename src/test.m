close all;
m = otp.mfshallowwatersphere.presets.Canonical;

y0 = m.Y0;

n = numel(y0);


% f = @(y) m.Constraints(0, y);
% f0 = m.Constraints(0, m.Y0);
% G = zeros(3, n);
% Ga = m.ConstraintsDerivative(0, m.Y0);
% h = 1e-4;
% for i = 1:n
%     e = zeros(n, 1);
%     e(i) = 1;  
%     G(:, i) = (f(y0 + h*e) - f0)/h;
% end
% abs(G - Ga)./abs(G)
% norm(G - Ga)/norm(G)
% imagesc(G - Ga)
% return

dt = 250;

f = m.Rhs.F;
g = m.Constraints;
dg = @(t, y) m.ConstraintsDerivative(t, y).';


 a_coe = [[0, 0];
        [1,0]];

ah_coe = [[0,0];
          [1/2,1/2]];

c_coe = [0; 1];
ch_coe = [0; 1];
b_coe = [1/2,1/2];

tss = HalfExplicit_RK_NonLin2FAST(a_coe, ah_coe, b_coe, c_coe, ch_coe, 100, 1e-8);

steps = 1e6;

fig1 = figure;

figure;
tiledlayout(3, 1);
nexttile
fig2 = plot(nan(steps, 1), 'LineWidth', 1.2);
title('Mass')
%nexttile
%fig3 = plot(nan(steps, 1), 'LineWidth', 1.2);
%title('Vorticity')
nexttile
fig3 = plot(nan(steps, 1), 'LineWidth', 1.2);
title('Enstrophy')
nexttile
fig4 = plot(nan(steps, 1), 'LineWidth', 1.2);
title('Energy')


nz = numel(g(0, m.Y0));

cons = zeros(nz, 1);


Z = m.Y0;
z0 = zeros(nz, 1);
for i = 1:steps
    
    %[Z, z0] = tss.time_step(func, phi, Jac, dt, i*dt, Z, z0);

    [Z, z0] = tss.time_step(f, dg, g, dt, i*dt, Z, z0);


    %sol = ode45(f, [0, dt], Z, odeset('AbsTol', 1e-1));
    %Z = sol.y(:, end);

    %     [~, Z] = RK65SSP33(func, [0 dt], Z, atol, rtol);
    phii = g(0, Z);

    cons(:, i) = phii;

    if rem(i, 500) == 0

        g(0, Z)

        figure(fig1);
        m.plotSphere(Z);
        drawnow;

%         [hn, un, vn] = rs(Z);
% 
%         pv = hn;
% 
%         fig1.CData = [pv; pv(1, :)].';
%         fig1.FaceColor = 'interp';
%         tt1.String = "Time = "+ i*dt/3600/24 +" days";
%         drawnow;
% 
        fig2.YData(1:i) = cons(1, 1:i);
        fig3.YData(1:i) = cons(2, 1:i);
        %fig4.YData(1:i) = cons(3, 1:i);
        %fig5.YData(1:i) = cons(4, 1:i);
        disp("Time = "+i*dt/3600/24+" days");
        drawnow;

    end

    

end



%abs(G - Ga)./abs(G)

%imagesc(Ga - G)


