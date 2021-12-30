classdef VanderpolProblem < otp.Problem
    %VANDERPOLPROBLEM
    %
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
            epsilon = obj.Parameters.Epsilon;
            
            obj.Rhs = otp.Rhs(@(t, y) otp.vanderpol.f(t, y, epsilon), ...
                'Jacobian', @(t, y) otp.vanderpol.jac(t, y, epsilon));
            
            obj.RhsStiff = otp.Rhs(@(t, y) otp.vanderpol.fstiff(t, y, epsilon), ...
                'Jacobian', @(t, y) otp.vanderpol.jacstiff(t, y, epsilon));
            
            obj.RhsNonstiff = otp.Rhs(@(t, y) otp.vanderpol.fnonstiff(t, y, epsilon), ...
                'Jacobian', otp.vanderpol.jacnonstiff(epsilon));
        end
    end
end

