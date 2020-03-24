classdef AllenCahnProblem < otp.Problem
    
    methods
        function obj = AllenCahnProblem(timeSpan, y0, parameters)
            obj@otp.Problem('Allen-Cahn Problem', [], timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            n = obj.Parameters.n;
            alpha = obj.Parameters.alpha;
            beta = obj.Parameters.beta;
            forcing = obj.Parameters.forcing;
            
            domain = [0, 1; 0, 1];
            L = otp.utils.pde.laplacian([n n], domain, [1, 1], 'NN');
            
            if isempty(forcing)
                f = @(t, y) otp.allencahn.fnoforce(t, y, L, alpha, beta, forcing);
            else
                [x, y] = meshgrid(linspace(0, 1, n), linspace(0, 1, n));
                x = x(:);
                y = y(:);
                ft = @(t) forcing(t, x, y);
                f = @(t, y) otp.allencahn.f(t, y, L, alpha, beta, ft);
            end
            
            obj.Rhs = otp.Rhs(f, ...
                otp.Rhs.FieldNames.Jacobian, @(t, u) otp.allencahn.jac(t, u, L, alpha, beta, forcing));
            
        end
        
        function validateNewState(obj, newTimeSpan, newY0, newParameters)
            validateNewState@otp.Problem(obj, ...
                newTimeSpan, newY0, newParameters)
            
            otp.utils.StructParser(newParameters) ...
                .checkField('alpha', 'scalar', 'real', 'finite', 'positive') ...
                .checkField('beta', 'scalar', 'real', 'finite', 'positive') ...
                .checkField('forcing', @(f) isempty(f) || isa(f, 'function_handle'));
        end
        
        function sol = internalSolve(obj, varargin)
            sol = internalSolve@otp.Problem(obj, 'Method', @ode15s, varargin{:});
        end
    end
end
