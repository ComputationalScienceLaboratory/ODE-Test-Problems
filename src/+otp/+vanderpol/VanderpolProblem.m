classdef VanderpolProblem < otp.Problem
    methods
        function obj = VanderpolProblem(timeSpan, y0, parameters)
            obj@otp.Problem('van der Pol', 2, timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            epsilon = obj.Parameters.epsilon;
            
            obj.Rhs = otp.Rhs(@(t, y) otp.vanderpol.f(t, y, epsilon), ...
                otp.Rhs.FieldNames.Jacobian, @(t, y) otp.vanderpol.jac(t, y, epsilon));
        end
        
        function validateNewState(obj, newTimeSpan, newY0, newParameters)
            validateNewState@otp.Problem(obj, newTimeSpan, newY0, newParameters)
            
            otp.utils.StructParser(newParameters) ...
                .checkField('epsilon', 'scalar', 'real', 'finite', 'nonnegative');
        end
        
        function sol = internalSolve(obj, varargin)
            sol = internalSolve@otp.Problem(obj, 'Method', @ode15s, varargin{:});
        end
    end
end

