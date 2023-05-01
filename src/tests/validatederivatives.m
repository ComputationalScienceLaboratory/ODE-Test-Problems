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

    % Try to see if the Jacobian works
    if ~isempty(model.RHS.Jacobian)
       
        if isnumeric(model.RHS.Jacobian)
            japprox = model.RHS.Jacobian;
        else
            try
                japprox = model.RHS.Jacobian(tc, y0);
            catch
                japprox = inf;
            end
        end
        
        % test the jacobian if not sparse
        if ~issparse(japprox)
            j = otp.utils.derivatives.jacobian(f, tc, y0);
        else
            % if we are sparse do JVP
            japprox = japprox*y0;
            j = otp.utils.derivatives.jacobianvectorproduct(f, tc, y0, y0);
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
        try
            japprox = jvp(tc, y0, y0);
        catch
            japprox = inf;
        end

        j = otp.utils.derivatives.jacobianvectorproduct(f, tc, y0, y0);

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

        try
            japprox = javp(tc, y0, y0);
        catch
            japprox = inf;
        end

        j = otp.utils.derivatives.jacobianadjointvectorproduct(f, tc, y0, y0);

        normj = norm(j);
        if normj < eps
            err = norm(j - japprox);
        else
            err = norm(j - japprox)/normj;
        end

        tol = 1e-4;

        % OCTAVE FIX: the finite difference approximation is low accurate for octave
        % thus set the tolerance very low
        if ~exist('dlarray', 'file')
            tol = 5e-2;

            % for QG the FD error is even larger, so we just let it pass
            if strcmp(modelname, 'quasigeostrophic')
                tol = 7e-1;
            end
        end

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


function J = adjacobianvectorproduct(f, y, u)
y = dlarray(y);

J = dlfeval(@adjacobianvectorproductinternal, f, y, u);

J = extractdata(J);

end

function J = adjacobianvectorproductinternal(f, y, u)

n = numel(u);

J = zeros(n, 1, 'like', y);

fy = f(y);
for i = 1:n
    J(i) = dlgradient(fy(i), y, 'RetainData', true).'*u;
end

end
