classdef RangAngermannProblem < otp.Problem
    % This is an Index-1 PDAE
    %
    % See
    %  Rang, J., & Angermann, L. (2005). 
    %  New Rosenbrock W-methods of order 3 for partial differential algebraic equations of index 1. 
    %  BIT Numerical Mathematics, 45, 761-787.
    %
    
    methods
        function obj = RangAngermannProblem(timeSpan, y0, parameters)
            obj@otp.Problem('Rang-Angermann Problem', [], timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            n = obj.Parameters.Size;
            forcingu = obj.Parameters.ForcingU;
            forcingv = obj.Parameters.ForcingV;
            FBCu = obj.Parameters.BoundaryConditionsU;
            FBCv = obj.Parameters.BoundaryConditionsV;

            if obj.NumVars ~= n^2
                warning('OTP:inconsistentNumVars', ...
                    'NumVars is %d, but there are %d grid points', ...
                    obj.NumVars, n^2);
            end

            % First we construct the finite difference operators in the
            % full domain including the boundary conditions
            nfull = n + 2;
            
            hx = 1/(n + 3);
            hy = 1/(n + 3);
            % one dimensional derivative in the x direciton
            Ddx = spdiags(repmat([-1 1 0]/(hx), nfull, 1), [-1, 0, 1], nfull, nfull);
            % two dimensional derivative in the x direction
            Dx = kron(speye(nfull), Ddx);

            % one dimensional derivative in the y direciton
            Ddy = spdiags(repmat([-1 1 0]/(hy), nfull, 1), [-1, 0, 1], nfull, nfull);
            % two dimensional derivative in the y direction
            Dy = kron(Ddy, speye(nfull));

            % both one dimensional Laplacians
            Ldx = spdiags(repmat([1 -2 1]/(hx^2), nfull, 1), [-1, 0, 1], nfull, nfull);
            Ldy = spdiags(repmat([1 -2 1]/(hy^2), nfull, 1), [-1, 0, 1], nfull, nfull);

            % two dimensional Laplacian
            L = kron(speye(nfull), Ldx) + kron(Ldy, speye(nfull));

            % construct the x-y grid
            xb = linspace(0, 1, nfull);
            yb = linspace(0, 1, nfull);

            [y, x] = meshgrid(xb, yb);


            % internal point grid
            xinternal = x(2:(end - 1), 2:(end - 1));
            yinternal = y(2:(end - 1), 2:(end - 1));

            % construct the x derivative operator on the internal grid
            Dxinternal = kron(speye(n), Ddx(2:(end - 1), 2:(end - 1)));
            % construct the y derivative operator on the internal grid
            Dyinternal = kron(Ddy(2:(end - 1), 2:(end - 1)), speye(n));
            % construct the Laplacian on the internal grid
            Linternal = kron(speye(n), Ldx(2:(end - 1), 2:(end - 1))) ...
                + kron(Ldy(2:(end - 1), 2:(end - 1)), speye(n));

            % construct the mass matrix
            Md = [ones(n^2, 1); zeros(n^2, 1)];
            M = spdiags(Md, 0, 2*(n^2), 2*(n^2));
            
            % construct the RHS
            obj.RHS = otp.RHS(@(t, uv) otp.rangangermann.f(t, uv, L, Dx, Dy, x, y, forcingu, forcingv, FBCu, FBCv), ...
                'Jacobian', @(t, uv) otp.rangangermann.jacobian(t, uv, Linternal, Dxinternal, Dyinternal, xinternal, yinternal, forcingu, forcingv, FBCu, FBCv), ...
                'Mass', M);
            
        end

        function uv = internalSolveExactly(obj, t)
            n = obj.Parameters.Size;
            nfull = n + 2;

            % construct the x-y grid
            xb = linspace(0, 1, nfull);
            yb = linspace(0, 1, nfull);

            [y, x] = meshgrid(xb, yb);

            % internal point grid
            xinternal = x(2:(end - 1), 2:(end - 1));
            yinternal = y(2:(end - 1), 2:(end - 1));

            for i = length(t):-1:1
                u = obj.Parameters.BoundaryConditionsU(t(i), xinternal, yinternal);
                u = reshape(u, [], 1);
                v = obj.Parameters.BoundaryConditionsV(t(i), xinternal, yinternal);
                v = reshape(v, [], 1);
                uv(:, i) = [u; v];
            end
        end
    end
end
