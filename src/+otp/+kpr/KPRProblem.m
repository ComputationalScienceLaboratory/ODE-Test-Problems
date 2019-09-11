classdef KPRProblem < otp.Problem
    properties (SetAccess = private)
        RhsFast
        RhsSlow
    end
    
    methods
        function obj = KPRProblem(timeSpan, y0, parameters)
            obj@otp.Problem('KPR', 2, timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            Omega = obj.Parameters.omegaMatrix;
            omega = obj.Parameters.omega;
            
            obj.Rhs = otp.Rhs(@(t,y) otp.kpr.f(t, y, Omega, omega), ...
                otp.Rhs.FieldNames.Jacobian, @(t, y) otp.kpr.jac(t, y, Omega, omega));
            
            obj.RhsFast = otp.Rhs(@(t,y) otp.kpr.ffast(t, y, Omega, omega), ...
                otp.Rhs.FieldNames.Jacobian, @(t, y) otp.kpr.jacfast(t, y, Omega, omega));
            
            obj.RhsSlow = otp.Rhs(@(t,y) otp.kpr.fslow(t, y, Omega, omega), ...
                otp.Rhs.FieldNames.Jacobian, @(t, y) otp.kpr.jacslow(t, y, Omega, omega));
        end
        
        function sol = internalSolve(obj, varargin)
            sol = internalSolve@otp.Problem(obj, 'Method', @ode15s, varargin{:});
        end
    end
end