problem = otp.cr3bp.presets.LowEarthOrbit;

y0 = problem.Y0;
tend = problem.TimeSpan(2);
f = problem.RHS.F;
mu = problem.Parameters.Mu;

v0 = -7;

J = @(v0) cost(v0, y0, f, tend, mu);
opts = optimoptions("fmincon", "Algorithm","interior-point", ...
            "FunctionTolerance", 1e-14, "ConstraintTolerance", 1e-14, 'Display','off');
[v0, fev] = fmincon(J, v0, [], [], [], [], [], [], [], opts);

v0

% find period

J = @(tend) cost2(v0, y0, f, tend, mu);
opts = optimoptions("fmincon", "Algorithm","interior-point", ...
            "FunctionTolerance", 1e-14, "ConstraintTolerance", 1e-14, 'Display','off');
[tend, fev] = fmincon(J, tend, [], [], [], [], 0.13, 0.15, [], opts);

tend


function c = cost(v0, y0, f, tend, mu)

y0(5) = v0;

sol = ode45(f, [0, tend], y0, ...
    odeset('AbsTol', 1e-14, 'RelTol', 100*eps));

yend = sol.y(:, :);

earth = [-mu; 0; 0];

dy0 = norm(y0(1:3) - earth);
dyend = vecnorm(yend(1:3, :) - earth);

c = sum((dy0 - dyend).^2);

end

function c = cost2(v0, y0, f, tend, ~)

y0(5) = v0;

sol = ode45(f, [0, tend], y0, ...
    odeset('AbsTol', 1e-14, 'RelTol', 100*eps));

c = sum((y0 - sol.y(:, end)).^2);

end
