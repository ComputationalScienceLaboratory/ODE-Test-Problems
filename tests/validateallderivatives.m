function validateallderivatives

fprintf('\n   Validating all model and preset derivatives \n\n');

fprintf(' Model                   | Preset               | Jacobian | JVP   | JAVP \n');
fprintf([repmat('-', 1, 88) '\n']);

presets = getpresets();

for preset = presets
        
    problemname = preset.problem;
    presetname = preset.name;
    presetclass = preset.presetclass;

    fprintf(' %-23s | %-20s | ', ...
        problemname, ...
        presetname);

    problem = evalpreset(presetclass, problemname, presetname);

    % setup
    tc = problem.TimeSpan(1);
    y0 = problem.Y0;
    f = problem.RHS.F;

    % OCTAVE FIX: the finite difference approximation is low accurate for octave
    % thus set the tolerance very high
    if exist('dlarray', 'file')
        tol = 1e-12;
    else
        tol = 1e-6;
    end

    % Compute the true Jacobian
    jtrue = otp.utils.derivatives.jacobian(f, tc, y0);

    % Try to see if the Jacobian works
    if ~isempty(problem.RHS.Jacobian)
        japprox = problem.RHS.JacobianFunction(tc, y0);
        japprox = full(japprox);

        normj = norm(jtrue);
        if normj < eps
            err = norm(jtrue - japprox);
        else
            err = norm(jtrue - japprox)/normj;
        end

        assert(err < tol, sprintf('Jacobian of preset %s of %s is incorrect with error %.5e', presetname, problemname, err));
        fprintf(' PASS    |')
    else
        fprintf('         |')
    end


    % test jacobian vector products
    if ~isempty(problem.RHS.JacobianVectorProduct)
        jvpapprox = problem.RHS.JacobianVectorProduct(tc, y0, y0);

        jvptrue = jtrue*y0;

        normj = norm(jvptrue);
        if normj < eps
            err = norm(jvptrue - jvpapprox);
        else
            err = norm(jvptrue - jvpapprox)/normj;
        end

        assert(err < tol, sprintf('JVP of preset %s of %s is incorrect with error %.5e', presetname, problemname, err));
        fprintf(' PASS  |')
    else
        fprintf('       |')
    end

    % test jacobian adjoint vector products
    if ~isempty(problem.RHS.JacobianAdjointVectorProduct)
        javpapprox = problem.RHS.JacobianAdjointVectorProduct(tc, y0, y0);

        javptrue = jtrue'*y0;

        normj = norm(javptrue);
        if normj < eps
            err = norm(javptrue - javpapprox);
        else
            err = norm(javptrue - javpapprox)/normj;
        end

        assert(err < tol, sprintf('JAVP of preset %s of %s is incorrect with error %.5e', presetname, problemname, err));
        fprintf(' PASS ')
    else
        fprintf('      ')
    end
    fprintf('\n')
end

end

