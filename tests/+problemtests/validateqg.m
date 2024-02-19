function validateqg

fprintf(' Testing Quasi-Geostrophic Equations\n');

model = otp.quasigeostrophic.presets.PopovMouIliescuSandu('size', [16, 32]);
model.TimeSpan = [0, 0.109];

[~] = otp.utils.Solver.Nonstiff(model.RHSADLES.F, model.TimeSpan, model.Y0);
fprintf('  Alternate ADLES RHS passed\n');

tc = model.TimeSpan(1);
y0 = model.Y0;

f = @(~, y) model.FlowVelocityMagnitude(y);
japprox = model.JacobianFlowVelocityMagnitudeVectorProduct(y0, y0);

jtrue = otp.utils.derivatives.jacobian(f, tc, y0)*y0;

normj = norm(jtrue);

if normj < eps
    err = norm(jtrue - japprox);
else
    err = norm(jtrue - japprox)/normj;
end

tol = 1e-6;
assert(err < tol);

fprintf('  Flow Velocity Magnitude Jacobian Vector product passed\n');


end

