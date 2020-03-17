function logo()

p = otp.lorenz63.presets.Canonical;
sol = p.solve;
t = linspace(sol.x(1), sol.x(end), 450);
y = deval(sol, t);

fig = p.plot(t, y', 'Title', 'ODE Test Problems', 'Legend', {});
fig.InvertHardcopy = 'off';
ax = fig.CurrentAxes;
ax.FontName = 'SansSerif';
ax.Title.FontSize = 22;

end