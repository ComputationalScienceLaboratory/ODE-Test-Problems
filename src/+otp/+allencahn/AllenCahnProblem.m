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
            
            domain = [0, 1; 0, 1];
            
            L = otp.utils.pde.laplacian([n n], domain, [1, 1], 'NN');
            
            obj.Rhs = otp.Rhs(@(t, u) otp.allencahn.f(t, u, L, alpha), ...
                otp.Rhs.FieldNames.Jacobian, @(t, u) otp.allencahn.jac(t, u, L, alpha));

        end
        
        function validateNewState(obj, newTimeSpan, newY0, newParameters)
            validateNewState@otp.Problem(obj, ...
                newTimeSpan, newY0, newParameters)
            
            otp.utils.StructParser(newParameters) ...
                .checkField('alpha', 'finite', 'positive');
        end
        
        function sol = internalSolve(obj, varargin)
            sol = internalSolve@otp.Problem(obj, 'Method', @ode15s, varargin{:});
        end
    end
end
