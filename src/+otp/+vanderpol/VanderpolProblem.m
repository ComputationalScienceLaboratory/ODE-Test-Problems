classdef VanderpolProblem < otp.Problem
    methods
        function obj = VanderpolProblem(timeSpan, y0, parameters)
            obj@otp.Problem('van der Pol', 2, timeSpan, y0, parameters);
        end
    end
    
    properties (SetAccess = private)
        RhsStiff
        RhsNonstiff
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            epsilon = obj.Parameters.epsilon;
            
            obj.Rhs = otp.Rhs(@(t, y) otp.vanderpol.f(t, y, epsilon), ...
                otp.Rhs.FieldNames.Jacobian, @(t, y) otp.vanderpol.jac(t, y, epsilon));
            
            obj.RhsStiff = otp.Rhs(@(t, y) otp.vanderpol.fstiff(t, y, epsilon), ...
                otp.Rhs.FieldNames.Jacobian, @(t, y) otp.vanderpol.jacstiff(t, y, epsilon));
            
            obj.RhsNonstiff = otp.Rhs(@(t, y) otp.vanderpol.fnonstiff(t, y, epsilon), ...
                otp.Rhs.FieldNames.Jacobian, @(t, y) otp.vanderpol.jacnonstiff(t, y, epsilon));
        end
        
        function validateNewState(obj, newTimeSpan, newY0, newParameters)
            validateNewState@otp.Problem(obj, newTimeSpan, newY0, newParameters)
            
             otp.utils.StructParser(newParameters) ...
                 .checkField('epsilon', 'scalar', 'real', 'finite', 'nonnegative');
        end
    end
end

