classdef RangAngermannProblem < otp.Problem
    %RangAngermannProblem
    
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

            %full domain
            nfull = n + 2;
            
            hx = 1/(n + 3);
            hy = 1/(n + 3);
            Ddx = spdiags(repmat([-1 1 0]/(hx), nfull, 1), [-1, 0, 1], nfull, nfull);
            Dx = kron(speye(nfull), Ddx);

            Ddy = spdiags(repmat([-1 1 0]/(hy), nfull, 1), [-1, 0, 1], nfull, nfull);
            Dy = kron(Ddy, speye(nfull));

            Ldx = spdiags(repmat([1 -2 1]/(hx^2), nfull, 1), [-1, 0, 1], nfull, nfull);
            Ldy = spdiags(repmat([1 -2 1]/(hy^2), nfull, 1), [-1, 0, 1], nfull, nfull);


            L = kron(speye(nfull), Ldx) + kron(Ldy, speye(nfull));

            xb = linspace(0, 1, nfull);
            yb = linspace(0, 1, nfull);

            [y, x] = meshgrid(xb, yb);

            xsmall = x(2:(end - 1), 2:(end - 1));
            ysmall = y(2:(end - 1), 2:(end - 1));

            Lsmall = kron(speye(n), Ldx(2:(end - 1), 2:(end - 1))) ...
                + kron(Ldy(2:(end - 1), 2:(end - 1)), speye(n));
            Dxsmall = kron(speye(n), Ddx(2:(end - 1), 2:(end - 1)));
            Dysmall = kron(Ddy(2:(end - 1), 2:(end - 1)), speye(n));

            Md = [ones(n^2, 1); zeros(n^2, 1)];
            M = spdiags(Md, 0, 2*(n^2), 2*(n^2));
            
            obj.RHS = otp.RHS(@(t, uv) otp.rangangermann.f(t, uv, L, Dx, Dy, x, y, forcingu, forcingv, FBCu, FBCv), ...
                'Jacobian', @(t, uv) otp.rangangermann.jacobian(t, uv, Lsmall, Dxsmall, Dysmall, xsmall, ysmall, forcingu, forcingv, FBCu, FBCv), ...
                'Mass', M);
            
        end
    end
end
