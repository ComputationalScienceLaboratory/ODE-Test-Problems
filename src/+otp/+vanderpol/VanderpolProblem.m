classdef VanderpolProblem < otp.Problem
    %VANDERPOLPROBLEM
    %
    methods
        function obj = VanderpolProblem(timeSpan, y0, parameters)
            obj@otp.Problem('van der Pol', 2, timeSpan, y0, parameters);
        end
    end
    
    properties (SetAccess = private)
       RHSStiff
       RHSNonstiff
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            epsilon = obj.Parameters.Epsilon;
            
            obj.RHS = otp.RHS(@(t, y) otp.vanderpol.f(t, y, epsilon), ...
                'Jacobian', @(t, y) otp.vanderpol.jacobian(t, y, epsilon), ...
                'Vectorized', 'on');
            
            obj.RHSStiff = otp.RHS(@(t, y) otp.vanderpol.fstiff(t, y, epsilon), ...
                'Jacobian', @(t, y) otp.vanderpol.jacobianstiff(t, y, epsilon), ...
                'Vectorized', 'on');
            
            obj.RHSNonstiff = otp.RHS(@(t, y) otp.vanderpol.fnonstiff(t, y, epsilon), ...
                'Jacobian', otp.vanderpol.jacobiannonstiff(epsilon), ...
                'Vectorized', 'on');
        end
    end
end

