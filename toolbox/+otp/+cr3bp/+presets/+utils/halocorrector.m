orbittypes = {'L2', 'P2HO1', 'P2HO2', 'P4HO1', 'P4HO2'};
nIndices = 20;

orbits = struct;

for oti = 1:numel(orbittypes)
    ot = orbittypes{oti};
    otable = zeros(20, 4);
    for ind = 1:nIndices

        problem = otp.cr3bp.presets.HaloOrbit('OrbitType', ot, 'Index', ind);

        y0 = problem.Y0;
        y0 = [y0(1); y0(3); y0(5)];
        period = problem.TimeSpan(2);
        f = problem.RHS.F;

        J = @(yc) cost(yc, y0);
        nonlc = @(yc) constr(yc, f, period);

        opts = optimoptions("fmincon", "Algorithm","interior-point", ...
            "FunctionTolerance", 1e-8, "ConstraintTolerance", 1e-14, 'Display','off');
        [ynew, fev] = fmincon(J, y0, [], [], [], [], [], [], nonlc, opts);

        otable(ind, :) = [period, ynew.'];

    end
    orbits.(ot) = otable;
end

function c = cost(yc, y0)

c = sum((yc - y0).^2);

end

function [c, ceq] = constr(yc, f, period)

yc = [yc(1); 0; yc(2); 0; yc(3); 0];

c = [];

sol = ode45(f, [0, period], yc, ...
    odeset('AbsTol', 1e-14, 'RelTol', 100*eps));

ceq = sum((yc - sol.y(:, end)).^2);

end


