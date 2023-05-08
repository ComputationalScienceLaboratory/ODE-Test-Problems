classdef SanzSernaProblem < otp.Problem
    % This test problem comes from
    % Sanz-Serna, J. M., Verwer, J. G., & Hundsdorfer, W. H. (1986). Convergence and order reduction of Runge-Kutta schemes
    % applied to evolutionary problems in partial differential equations. Numerische Mathematik, 50(4), 405–418.
    % https://doi.org/10.1007/BF01396661
    
    properties (SetAccess = private)
       RHSLinear
       RHSForcing
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
            
            obj.RHS = otp.RHS(@(t, y) otp.sanzserna.f(t, y, D, x), ...
                'Jacobian', otp.sanzserna.jacobian(D, x), ...
                'JacobianVectorProduct', @(t, y, v) otp.sanzserna.jacobianVectorProduct(t, y, v, D, x), ...
                'PartialDerivativeTime', @(t, y) otp.sanzserna.partialDerivativeTime(t, y, D, x), ...
                'Vectorized', 'on');
            
            obj.RHSLinear = otp.RHS(@(t, y) otp.sanzserna.fLinear(t, y, D, x), ...
                'Jacobian', otp.sanzserna.jacobianLinear(D, x), ...
                'Vectorized', 'on');
            obj.RHSForcing = otp.RHS(@(t, y) otp.sanzserna.fForcing(t, y, D, x), ...
                'Jacobian', otp.sanzserna.jacobianForcing(D, x), ...
                'Vectorized', 'on');
        end
        
        function sol = internalSolve(obj, varargin)
            sol = internalSolve@otp.Problem(obj, 'Solver', otp.utils.Solver.Nonstiff, varargin{:});
        end
        
        %true solution
    end
end
