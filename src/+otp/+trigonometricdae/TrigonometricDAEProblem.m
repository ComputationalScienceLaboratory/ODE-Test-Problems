classdef TrigonometricDAEProblem < otp.Problem
    methods
        function obj = TrigonometricDAEProblem(timeSpan, y0, parameters)
            obj@otp.Problem('Trigonometric DAE', 2, timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            obj.RHS = otp.RHS(@(t, y) otp.trigonometricdae.f(t, y), ...
                'Jacobian', @(t, y) otp.trigonometricdae.jacobian(t, y), ...
                'Mass', otp.trigonometricdae.mass([], []), ...
                'MassSingular', 'yes', ...
                'Vectorized', 'on');
        end
        
        function y = internalSolveExactly(obj, t)
            if ~isequal(obj.Y0, [sinh(0.5); tanh(0.5)])
                error('OTP:noExactSolution', ...
                    'An exact solution is unavailable for this initial condition');
            end
            
            y = [sinh(t); tanh(t)];
        end
    end
end

