classdef SanzSernaProblem < otp.Problem
    % This test problem comes from
    % Sanz-Serna, J. M., Verwer, J. G., & Hundsdorfer, W. H. (1986). Convergence and order reduction of Runge-Kutta schemes
    % applied to evolutionary problems in partial differential equations. Numerische Mathematik, 50(4), 405–418.
    % https://doi.org/10.1007/BF01396661
    
    properties (SetAccess = private)
        RhsLinear
        RhsForcing
    end
    
    methods
        function obj = SanzSernaProblem(timeSpan, y0, parameters)
            obj@otp.Problem('Sanz-Serna', [], timeSpan, y0, parameters);
        end
    end
    
    methods (Access=protected)
        
        function onSettingsChanged(obj)
            
            D = spdiags(ones(obj.NumVars, 1) * [obj.NumVars, -obj.NumVars], [-1, 0], obj.NumVars, obj.NumVars);
            
            x = linspace(1/obj.NumVars, 1, obj.NumVars).';
            
            obj.Rhs = otp.Rhs(@(t, y) otp.sanzserna.f(t, y, D, x), ...
                otp.Rhs.FieldNames.Jacobian, @(t, y) otp.sanzserna.jac(t, y, D, x), ...
                otp.Rhs.FieldNames.JacobianVectorProduct, @(t, y, v) otp.sanzserna.jvp(t, y, v, D, x), ...
                otp.Rhs.FieldNames.PartialDerivativeTime, @(t, y) otp.sanzserna.pdt(t, y, D, x));
            
            obj.RhsLinear = otp.Rhs(@(t, y) otp.sanzserna.flinear(t, y, D, x), ...
                otp.Rhs.FieldNames.Jacobian, @(t, y) otp.sanzserna.jaclinear(t, y, D, x));
            obj.RhsForcing = otp.Rhs(@(t, y) otp.sanzserna.fforcing(t, y, D, x), ...
                otp.Rhs.FieldNames.Jacobian, @(t, y) otp.sanzserna.jacforcing(t, y, D, x));
        end
        
        function sol = internalSolve(obj, varargin)
            sol = internalSolve@otp.Problem(obj, 'Method', @ode45, varargin{:});
        end
        
        %true solution
    end
end
