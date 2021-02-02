classdef Lorenz96Problem <  otp.Problem
    % Lorenz96Problem  The Lorenz 96 model is a classic model for testing data assimilation techniques.
    % The specifics of this model can be found elsewhere. I will discuss the implementation details.
    % Here we have an implementation of a Parametres.numVars variable Lorenz 96 system
    
    properties (SetAccess = private)
        DistanceFunction
    end
    
    methods
        function obj = Lorenz96Problem(timeSpan, y0, parameters)
            obj@ otp.Problem('Lorenz-96', [], timeSpan, y0, parameters);
        end
    end
    
    methods (Access=protected)
        function validateNewState(obj, newTimeSpan, newY0, newParameters)
            validateNewState@otp.Problem(obj, newTimeSpan, newY0, newParameters)
            
            otp.utils.StructParser(newParameters) ...
                .checkField('forcingFunction', @(x) isnumeric(x) || isa(x, 'function_handle'));
        end
        
        function obj = onSettingsChanged(obj)
            ff = obj.Parameters.forcingFunction;
            
            if isa(ff, 'function_handle')
                f = @(t, y) otp.lorenz96.f(t, y, ff);
            else
                f = @(t, y) otp.lorenz96.fconst(t, y, ff);
            end
            
            obj.Rhs = otp.Rhs(f, ...
                otp.Rhs.FieldNames.Jacobian, ...
                @(t, y) otp.lorenz96.jac(t, y), ...
                otp.Rhs.FieldNames.JacobianVectorProduct, ...
                @(t, y, u) otp.lorenz96.jvp(t, y, u), ...
                otp.Rhs.FieldNames.JacobianAdjointVectorProduct, ...
                @(t, y, u) otp.lorenz96.javp(t, y, u), ...
                otp.Rhs.FieldNames.HessianVectorProduct, ...
                @(t, y, u, v) otp.lorenz96.hvp(t, y, u, v), ...
                otp.Rhs.FieldNames.HessianAdjointVectorProduct, ...
                @(t, y, u, v) otp.lorenz96.havp(t, y, u, v));
            
            % We also provide a canonical distance function as is standard for
            % localisation in Data Assimilation. This is heavily tied to this
            % problem.
            
            obj.DistanceFunction = @(t, y, i, j) otp.lorenz96.distfn(t, y, i, j);
        end
        
        function sol = internalSolve(obj, varargin)
            sol = internalSolve@otp.Problem(obj, 'Method', @ode45, varargin{:});
        end
        
        function mov = internalMovie(obj, t, y, varargin)
            mov = otp.utils.movie.LineMovie('title', obj.Name, varargin{:});
            mov.record(t, y);
        end
    end
end
