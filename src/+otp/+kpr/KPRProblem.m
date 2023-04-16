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
            
            obj.RHSFast = otp.RHS(@(t,y) otp.kpr.fFast(t, y, lambda, omega), ...
                'Jacobian', @(t, y) otp.kpr.jacobianFast(t, y, lambda, omega));
            
            obj.RHSSlow = otp.RHS(@(t,y) otp.kpr.fSlow(t, y, lambda, omega), ...
                'Jacobian', @(t, y) otp.kpr.jacobianSlow(t, y, lambda, omega));
        end
        
        function y = internalSolveExactly(obj, t)
            if ~isequal(obj.Y0, [2; sqrt(3)])
                error('OTP:noExactSolution', ...
                    'An exact solution is unavailable for this initial condition');
            end
            
            y = sqrt([3 + cos(obj.Parameters.Omega * t); 2 + cos(t)]);
        end
    end
end
