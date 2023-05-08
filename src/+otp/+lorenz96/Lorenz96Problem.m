classdef Lorenz96Problem <  otp.Problem
    %LORENZ96PROBLEM  The Lorenz 96 model is a classic model for testing data assimilation techniques.
    % 
    % See also otp.loren96.Lorenz96Parameters
    
    properties (SetAccess = private)
        DistanceFunction
    end
    
    methods
        function obj = Lorenz96Problem(timeSpan, y0, parameters)
            obj@ otp.Problem('Lorenz ''96', [], timeSpan, y0, parameters);
        end
    end
    
    methods (Access=protected)
        function obj = onSettingsChanged(obj)
            forcing = obj.Parameters.F;
            
            if isa(forcing, 'function_handle')
                f = @(t, y) otp.lorenz96.f(t, y, forcing);
            else
                f = @(t, y) otp.lorenz96.fConst(t, y, forcing);
            end
            
            obj.RHS = otp.RHS(f, ...
                'Jacobian', ...
                @(t, y) otp.lorenz96.jacobian(t, y), ...
                'JacobianVectorProduct', ...
                @(t, y, u) otp.lorenz96.jacobianVectorProduct(t, y, u), ...
                'JacobianAdjointVectorProduct', ...
                @(t, y, u) otp.lorenz96.jacobianAdjointVectorProduct(t, y, u), ...
                'HessianVectorProduct', ...
                @(t, y, u, v) otp.lorenz96.hessianVectorProduct(t, y, u, v), ...
                'HessianAdjointVectorProduct', ...
                @(t, y, u, v) otp.lorenz96.hessianAdjointVectorProduct(t, y, u, v), ...
                'Vectorized', 'on');
            
            % We also provide a canonical distance function as is standard for
            % localisation in Data Assimilation. This is heavily tied to this
            % problem.
            
            obj.DistanceFunction = @(t, y, i, j) otp.lorenz96.distanceFunction(t, y, i, j);
        end
        
        function sol = internalSolve(obj, varargin)
            sol = internalSolve@otp.Problem(obj, ...
                'Solver', otp.utils.Solver.Nonstiff, varargin{:});
        end
        
        function mov = internalMovie(obj, t, y, varargin)
            mov = otp.utils.movie.LineMovie('title', obj.Name, varargin{:});
            mov.record(t, y);
        end
    end
end
