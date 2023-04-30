function [passed, failed] = validatederivatives

pi = otptests.PresetIterator;

passed = 0;
failed = 0;

for preset = pi.PresetList
        
    modelname = preset.modelName;
    presetname = preset.presetName;
    presetclass = preset.presetClass;

    if strcmp(modelname, 'qg')
        presetclass = sprintf('%s%s', presetclass, "('size', [16, 32])");
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
    n = model.NumVars;
    h = mean(sqrt(eps(y0)));

    if strcmp(modelname, 'protherorobinson')
        h = sqrt(eps);
    end

    % Try to see if the Jacobian works
    if ~isempty(model.RHS.Jacobian)
       
        if isnumeric(model.RHS.Jacobian)
            japprox = model.RHS.Jacobian;
        else
            japprox = model.RHS.Jacobian(tc, y0);
        end
        
        % test the jacobian if not sparse
        if ~issparse(japprox)
            % finite difference
            j = zeros(n, n);
            for i = 1:n
                e = zeros(n, 1);
                e(i) = 1;
                diff = f(tc, y0 + 1*h*e) - f(tc, y0 - 1*h*e);
                j(:, i) = diff/(2*h);
            end
        else
            % if we are sparse do JVP
            japprox = japprox*y0;
            diff = f(tc, y0 + 1*h*y0) - f(tc, y0 - 1*h*y0);
            j = diff/(2*h);
        end

        normj = norm(j);
        if normj < eps
            err = norm(j - japprox);
        else
            err = norm(j - japprox)/normj;
        end

        tol = 1e-4;

        % we might have to set the tolerances higher for certain
        % problems

        if err < tol
            fprintf('The preset %s of the model %s has a valid Jacobian\n', presetname, modelname);
            passed = passed + 1;
        else
            fprintf('---- The preset %s of the model %s has an invalid Jacobian with error: %.3e\n', ...
                presetname, modelname, err)
            failed = failed + 1;
        end
    end


    % test jacobian vector products
    if ~isempty(model.RHS.JacobianVectorProduct)
        jvp = model.RHS.JacobianVectorProduct;
        japprox = jvp(tc, y0, y0);

        diff = f(tc, y0 + 1*h*y0) - f(tc, y0 - 1*h*y0);
        j = diff/(2*h);

        normj = norm(j);
        if normj < eps
            err = norm(j - japprox);
        else
            err = norm(j - japprox)/normj;
        end

        tol = 1e-4;

        if err < tol
            fprintf('The preset %s of the model %s has a valid JacobianVectorProduct\n', presetname, modelname);
            passed = passed + 1;
        else
            fprintf('---- The preset %s of the model %s has an invalid JacobianVectorProduct\n      with error: %.3e\n', ...
                presetname, modelname, err);
            failed = failed + 1;
        end
    end

    % test jacobian adjoint vector products
    if ~isempty(model.RHS.JacobianAdjointVectorProduct)
        
        javp = model.RHS.JacobianAdjointVectorProduct;
        japprox = javp(tc, y0, y0);


        if ~isempty(model.RHS.Jacobian)
            if isnumeric(model.RHS.Jacobian)
                ja = model.RHS.Jacobian';
            else
                ja = model.RHS.Jacobian(tc, y0)';
            end
            j = ja*y0;     
        else

            % build auxiliary function
            jvp = model.RHS.JacobianVectorProduct;
            g = @(t, x, u, v) jvp(t, x, u)'*v;

            j = zeros(n, 1);

            y = y0;
            u = y0;
            v = y0;

            for i = 1:n
                e = zeros(n, 1);
                e(i) = 1;
                diff = g(tc, y, u + 1*h*e, v) - g(tc, y, u - 1*h*e, v);
                j(i) = conj(diff)/(2*h);
            end

        end

        normj = norm(j);
        if normj < eps
            err = norm(j - japprox);
        else
            err = norm(j - japprox)/normj;
        end

        tol = 1e-4;

        if err < tol
            fprintf('The preset %s of the model %s has a valid JacobianAdjointVectorProduct\n', presetname, modelname);
            passed = passed + 1;
        else
            fprintf('---- The preset %s of the model %s has an invalid JacobianAdjointVectorProduct\n      with error: %.3e\n', ...
                presetname, modelname, err);
            failed = failed + 1;
        end
    end
end

end
