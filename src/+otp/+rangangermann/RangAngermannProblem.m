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
            
            domainx = [0, 1];
            domainy = [0, 1];
            domain = [domainx; domainy];
            L = otp.utils.pde.laplacian([n+2 n+2], domain, [1, 1], 'DD');
            Dx = otp.utils.pde.Dd([n+2 n+2], domainx, 1, 2, 'D');
            Dy = otp.utils.pde.Dd([n+2 n+2], domainy, 2, 2, 'D');

            xb = linspace(0, 1, n + 2);
            yb = linspace(0, 1, n + 2);

            [x, y] = meshgrid(xb, yb);

            xsmall = x(2:(end - 1), 2:(end - 1));
            ysmall = y(2:(end - 1), 2:(end - 1));

            hx = 1/(n + 3);
            hy = 1/(n + 3);
            domainxsmall = [hx, 1 - hx];
            domainysmall = [hy, 1 - hy];
            domainsmall = [domainxsmall; domainysmall];
            Lsmall = otp.utils.pde.laplacian([n, n], domainsmall, [1, 1], 'DD');
            Dxsmall = otp.utils.pde.Dd([n, n], domainxsmall, 1, 2, 'D');
            Dysmall = otp.utils.pde.Dd([n, n], domainysmall, 2, 2, 'D');

            Md = [ones(n^2, 1); zeros(n^2, 1)];
            M = spdiags(Md, 0, 2*(n^2), 2*(n^2));
            
            obj.RHS = otp.RHS(@(t, uv) otp.rangangermann.f(t, uv, L, Dx, Dy, x, y, forcingu, forcingv, FBCu, FBCv), ...
                'Jacobian', @(t, uv) otp.rangangermann.jacobian(t, uv, Lsmall, Dxsmall, Dysmall, xsmall, ysmall, forcingu, forcingv, FBCu, FBCv), ...
                'Mass', M);
            
        end
    end
end
