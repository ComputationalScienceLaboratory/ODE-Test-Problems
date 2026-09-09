function validateqg

fprintf(' Testing Allen-Cahn Equations\n');

forcings = {8, @(t, ~, ~) cos(t)};

for fi = 1:numel(forcings)
    forcing = forcings{fi};

    model = otp.allencahn.presets.Canonical('Size', 16, 'Forcing', forcing);
    model.Parameters.LinearizationPoint = model.Y0;

    %% Linear
    [~] = otp.utils.Solver.Nonstiff(model.RHSLinear.F, model.TimeSpan, model.Y0);
    fprintf('  Alternate RHSLinear RHS passed\n');

    %% Non-Linear
    [~] = otp.utils.Solver.Nonstiff(model.RHSLinear.F, model.TimeSpan, model.Y0);
    fprintf('  Alternate RHSNonlinear RHS passed\n');

    %% Reaction
    [~] = otp.utils.Solver.Nonstiff(model.RHSReaction.F, model.TimeSpan, model.Y0);
    fprintf('  Alternate RHSReaction RHS passed\n');

    tc = model.TimeSpan(1);
    y0 = model.Y0;

    f = @(t, y) model.RHSReaction.F(t, y);
    japprox = model.RHSReaction.Jacobian(tc, y0);
    jtrue = otp.utils.derivatives.jacobian(f, tc, y0);

    normj = norm(jtrue);

    if normj < eps
        err = norm(jtrue - japprox);
    else
        err = norm(jtrue - japprox)/normj;
    end

    tol = 1e-6;
    assert(err < tol);

    fprintf('   Reaction Jacobian passed\n');

    %% Diffusion
    [~] = otp.utils.Solver.Nonstiff(model.RHSDiffusion.F, model.TimeSpan, model.Y0);
    fprintf('  Alternate RHSDiffusion RHS passed\n');

    tc = model.TimeSpan(1);
    y0 = model.Y0;

    f = @(t, y) model.RHSDiffusion.F(t, y);
    japprox = model.RHSDiffusion.Jacobian(tc, y0);
    jtrue = otp.utils.derivatives.jacobian(f, tc, y0);

    normj = norm(jtrue);

    if normj < eps
        err = norm(jtrue - japprox);
    else
        err = norm(jtrue - japprox)/normj;
    end

    tol = 1e-6;
    assert(err < tol);

    fprintf('   Diffusion Jacobian passed\n');

end

end

