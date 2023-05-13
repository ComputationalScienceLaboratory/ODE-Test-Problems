function validateallderivatives

pi = PresetIterator;


fprintf('\n   Validating all model and preset derivatives \n\n');

fprintf([' Model                | Preset               |' ...
    ' Jacobian | JVP   | JAVP \n']);
fprintf([repmat('-', 1, 85) '\n']);

for preset = pi.PresetList
        
    modelname = preset.modelName;
    presetname = preset.presetName;
    presetclass = preset.presetClass;

    fprintf(' %-20s | %-20s | ', ...
        modelname, ...
        presetname);

    if strcmp(modelname, 'quasigeostrophic')
        presetclass = sprintf('%s%s', presetclass, "('size', [16, 32])");
    end

    if strcmp(modelname, 'allencahn')
        presetclass = sprintf('%s%s', presetclass, "('size', 16)");
    end

    try
        model = eval(presetclass);
    catch
        continue;
    end

    % setup
    tc = model.TimeSpan(1);
    y0 = model.Y0;
    f = model.RHS.F;

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
    if ~isempty(model.RHS.Jacobian)
        try
            japprox = model.RHS.JacobianFunction(tc, y0);
        catch
            japprox = inf;
        end
        japprox = full(japprox);

        normj = norm(jtrue);
        if normj < eps
            err = norm(jtrue - japprox);
        else
            err = norm(jtrue - japprox)/normj;
        end

        assert(err < tol, sprintf('Jacobian of preset %s of %s is incorrect with error %.5e', presetname, modelname, err));
        fprintf(' PASS    |')
    else
        fprintf('         |')
    end


    % test jacobian vector products
    if ~isempty(model.RHS.JacobianVectorProduct)
        try
            jvpapprox = model.RHS.JacobianVectorProduct(tc, y0, y0);
        catch
            jvpapprox = inf;
        end

        jvptrue = jtrue*y0;

        normj = norm(jvptrue);
        if normj < eps
            err = norm(jvptrue - jvpapprox);
        else
            err = norm(jvptrue - jvpapprox)/normj;
        end

        assert(err < tol, sprintf('JVP of preset %s of %s is incorrect with error %.5e', presetname, modelname, err));
        fprintf(' PASS  |')
    else
        fprintf('       |')
    end

    % test jacobian adjoint vector products
    if ~isempty(model.RHS.JacobianAdjointVectorProduct)

        try
            javpapprox = model.RHS.JacobianAdjointVectorProduct(tc, y0, y0);
        catch
            javpapprox = inf;
        end

        javptrue = jtrue'*y0;

        normj = norm(javptrue);
        if normj < eps
            err = norm(javptrue - javpapprox);
        else
            err = norm(javptrue - javpapprox)/normj;
        end

        assert(err < tol, sprintf('JAVP of preset %s of %s is incorrect with error %.5e', presetname, modelname, err));
        fprintf(' PASS ')
    else
        fprintf('      ')
    end
    fprintf('\n')
end

end

