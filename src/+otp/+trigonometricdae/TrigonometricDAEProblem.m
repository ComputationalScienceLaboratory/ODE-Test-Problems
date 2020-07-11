classdef TrigonometricDAEProblem < otp.Problem
    methods
        function obj = TrigonometricDAEProblem(timeSpan, y0, parameters)
            obj@otp.Problem('Trigonometric DAE', 2, timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            obj.Rhs = otp.Rhs(@(t, y) otp.trigonometricdae.f(t, y), ...
                otp.Rhs.FieldNames.Jacobian, @(t, y) otp.trigonometricdae.jac(t, y), ...
                otp.Rhs.FieldNames.Mass, otp.trigonometricdae.mass([], []), ...
                otp.Rhs.FieldNames.MassSingular, 'yes');
        end
        
        function sol = internalSolve(obj, varargin)
            sol = internalSolve@otp.Problem(obj, 'Method', @ode15s, varargin{:});
        end
    end
end

