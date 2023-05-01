function [passed, failed] = validatederivatives

pi = PresetIterator;

passed = 0;
failed = 0;

for preset = pi.PresetList
        
    modelname = preset.modelName;
    presetname = preset.presetName;
    presetclass = preset.presetClass;

    if strcmp(modelname, 'quasigeostrophic')
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

            if exist('dlarray', 'file')
                ftc = @(x) f(tc, x);
                j = adjacobian(ftc, y0);
            else
                % finite difference
                j = zeros(n, n);
                for i = 1:n
                    e = zeros(n, 1);
                    e(i) = 1;
                    diff = f(tc, y0 + 1*h*e) - f(tc, y0 - 1*h*e);
                    j(:, i) = diff/(2*h);
                end
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
            j
            japprox
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

            jvp = model.RHS.JacobianVectorProduct;
            v = y0;
            % build auxiliary function
            g = @(t, u) jvp(t, y0, u)'*v;

            j = zeros(n, 1);
            for i = 1:n
                e = zeros(n, 1);
                e(i) = 1;
                diff = finitediff(g, tc, y0, e, h);
                j(i) = conj(diff);
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


function d = finitediff(f, t, y, u, h)

d = (f(t, y + h*u) - f(t, y - h*u))/(2*h);

end

function J = adjacobian(f, y)
y = dlarray(y);

J = dlfeval(@adjacobianinternal, f, y);

J = extractdata(J);

end

function J = adjacobianinternal(f, y)

n = numel(y);

fy = f(y);

J = zeros(n, n, 'like', y);

for  i = 1:n
    J(i, :) = dlgradient(fy(i), y, 'RetainData', true).';
end

end
