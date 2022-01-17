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
    end
end

