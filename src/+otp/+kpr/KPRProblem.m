classdef KPRProblem < otp.Problem
    properties (SetAccess = private)
       RHSFast
       RHSSlow
    end
    
    methods
        function obj = KPRProblem(timeSpan, y0, parameters)
            obj@otp.Problem('KPR', 2, timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            lambda = obj.Parameters.Lambda;
            omega = obj.Parameters.Omega;
            
            obj.RHS = otp.RHS(@(t,y) otp.kpr.f(t, y, lambda, omega), ...
                'Jacobian', @(t, y) otp.kpr.jacobian(t, y, lambda, omega));
            
            obj.RHSFast = otp.RHS(@(t,y) otp.kpr.ffast(t, y, lambda, omega), ...
                'Jacobian', @(t, y) otp.kpr.jacfast(t, y, lambda, omega));
            
            obj.RHSSlow = otp.RHS(@(t,y) otp.kpr.fslow(t, y, lambda, omega), ...
                'Jacobian', @(t, y) otp.kpr.jacslow(t, y, lambda, omega));
        end
    end
end
