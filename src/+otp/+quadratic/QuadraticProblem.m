classdef QuadraticProblem < otp.Problem
    
    methods
        function obj = QuadraticProblem(timeSpan, y0, parameters)
            obj@otp.Problem('Quadratic Problem', [], timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            a = obj.Parameters.A;
            B = obj.Parameters.B;
            C = obj.Parameters.C;

            partialderivativeparameters = struct( ...
                'a', @(t, x) otp.quadratic.partialDerivativeA(t, x, a, B, C), ...
                'B',  @(t, x) otp.quadratic.partialDerivativeB(t, x, a, B, C), ...
                'C',  @(t, x) otp.quadratic.partialDerivativeC(t, x, a, B, C));
            
            obj.RHS = otp.RHS(@(t, x) otp.quadratic.f(t, x, a, B, C), ...
                'Jacobian', @(t, x) otp.quadratic.jacobian(t, x, a, B, C), ...
                'PartialDerivativeParameters', partialderivativeparameters);
        end
    end
end
