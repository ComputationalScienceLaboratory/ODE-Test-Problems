classdef QuadraticProblem < otp.Problem
    
    methods
        function obj = QuadraticProblem(timeSpan, y0, parameters)
            obj@otp.Problem('Quadratic', [], timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            a = obj.Parameters.A;
            B = obj.Parameters.B;
            C = obj.Parameters.C;
            
            obj.RHS = otp.RHS(@(t, x) otp.quadratic.f(t, x, a, B, C), ...
                'Jacobian', @(t, x) otp.quadratic.jacobian(t, x, a, B, C), ...
                'PartialDerivativeParameters', @(t, x) otp.quadratic.partialDerivativeParameters(t, x, a, B, C));
        end
    end
end
