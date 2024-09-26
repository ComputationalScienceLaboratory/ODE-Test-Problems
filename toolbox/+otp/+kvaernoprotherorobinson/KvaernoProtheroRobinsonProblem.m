classdef KvaernoProtheroRobinsonProblem < otp.Problem
    properties (SetAccess = private)
       RHSFast
       RHSSlow
    end
    
    methods
        function obj = KvaernoProtheroRobinsonProblem(timeSpan, y0, parameters)
            obj@otp.Problem('Kværnø–Prothero–Robinson', 2, timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            lambda = obj.Parameters.Lambda;
            omega = obj.Parameters.Omega;
            
            obj.RHS = otp.RHS(@(t,y) otp.kvaernoprotherorobinson.f(t, y, lambda, omega), ...
                'Jacobian', @(t, y) otp.kvaernoprotherorobinson.jacobian(t, y, lambda, omega));
            
            obj.RHSFast = otp.RHS(@(t,y) otp.kvaernoprotherorobinson.fFast(t, y, lambda, omega), ...
                'Jacobian', @(t, y) otp.kvaernoprotherorobinson.jacobianFast(t, y, lambda, omega));
            
            obj.RHSSlow = otp.RHS(@(t,y) otp.kvaernoprotherorobinson.fSlow(t, y, lambda, omega), ...
                'Jacobian', @(t, y) otp.kvaernoprotherorobinson.jacobianSlow(t, y, lambda, omega));
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
