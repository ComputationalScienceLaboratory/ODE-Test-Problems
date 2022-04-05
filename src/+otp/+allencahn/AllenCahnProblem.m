classdef AllenCahnProblem < otp.Problem
    %ALLENCAHNPROBLEM
    
    methods
        function obj = AllenCahnProblem(timeSpan, y0, parameters)
            obj@otp.Problem('Allen-Cahn Problem', [], timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function validateNewState(obj, newTimeSpan, newY0, newParameters)
            validateNewState@otp.Problem(obj, newTimeSpan, newY0, ...
                newParameters);
            
            y0Len = length(newY0);
            gridPts = newParameters.Size^2;
            
            if y0Len ~= gridPts
                warning('OTP:inconsistentNumVars', ...
                    'NumVars is %d, but there are %d grid points', ...
                    y0Len, gridPts);
            end
        end
        
        function onSettingsChanged(obj)
            n = obj.Parameters.Size;
            alpha = obj.Parameters.Alpha;
            beta = obj.Parameters.Beta;
            forcing = obj.Parameters.Forcing;
            
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
