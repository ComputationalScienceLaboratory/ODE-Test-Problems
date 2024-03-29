classdef AllenCahnProblem < otp.Problem
    %ALLENCAHNPROBLEM
    
    methods
        function obj = AllenCahnProblem(timeSpan, y0, parameters)
            obj@otp.Problem('Allen–Cahn', [], timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            n = obj.Parameters.Size;
            alpha = obj.Parameters.Alpha;
            beta = obj.Parameters.Beta;
            forcing = obj.Parameters.Forcing;
            
            if obj.NumVars ~= n^2
                warning('OTP:inconsistentNumVars', ...
                    'NumVars is %d, but there are %d grid points', ...
                    obj.NumVars, n^2);
            end
            
            domain = [0, 1; 0, 1];
            L = otp.utils.pde.laplacian([n n], domain, [1, 1], 'NN');
            
            if ~isa(forcing, 'function_handle')
                f = @(t, y) otp.allencahn.fConstForce(t, y, L, alpha, beta, forcing);
            else
                [x, y] = meshgrid(linspace(0, 1, n), linspace(0, 1, n));
                x = x(:);
                y = y(:);
                ft = @(t) forcing(t, x, y);
                f = @(t, y) otp.allencahn.f(t, y, L, alpha, beta, ft);
            end
            
            obj.RHS = otp.RHS(f, ...
                'Jacobian', @(t, u) otp.allencahn.jacobian(t, u, L, alpha, beta, forcing));
            
        end
    end
end
