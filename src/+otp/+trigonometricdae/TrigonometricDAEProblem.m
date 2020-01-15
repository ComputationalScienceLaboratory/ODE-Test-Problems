classdef TrigonometricDAEProblem < otp.Problem
    methods
        function obj = TrigonometricDAEProblem(timeSpan, y0, parameters)
            obj@otp.Problem('Trigonometric DAE', 2, timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            epsilon = obj.Parameters.epsilon;
            
            obj.Rhs = otp.Rhs(@(t, y) otp.trigonometricdae.f(t, y, epsilon), ...
                otp.Rhs.FieldNames.Jacobian, @(t, y) otp.trigonometricdae.jac(t, y, epsilon), ...
                otp.Rhs.FieldNames.MassMatrix, otp.trigonometricdae.mass([], [], epsilon));     
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

