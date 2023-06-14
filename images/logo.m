function logo()

p = otp.lorenz63.presets.Canonical;
sol = p.solve;
t = linspace(sol.x(1), sol.x(end), 450);
y = deval(sol, t);

fig = p.plot(t, y, 'Title', 'ODE Test Problems', 'Legend', {}, 'ColorOrder', hsv(3), 'FontName', 'SansSerif');
fig.InvertHardcopy = 'off';
fig.CurrentAxes.Title.FontSize = 22;

end
