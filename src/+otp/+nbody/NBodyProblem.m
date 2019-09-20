classdef NBodyProblem < otp.Problem
    methods
        function obj = NBodyProblem(timeSpan, y0, parameters)
            obj@otp.Problem('N-Body Problem', [], timeSpan, y0, parameters);
        end
    end
    
    methods(Access=protected)
        function onSettingsChanged(obj)
            spacialDim = obj.Parameters.spacialDim;
            masses = obj.Parameters.masses;
            g = obj.Parameters.gravitationalConstant;
            softeningLength = obj.Parameters.softeningLength;
            
            obj.Rhs = otp.Rhs(@(t, y) otp.nbody.f(t, y, spacialDim, masses, g, softeningLength));
        end
        
        function validateNewState(obj, newTimeSpan, newY0, newParameters)
            validateNewState@otp.Problem(obj, newTimeSpan, newY0, newParameters);
            
            otp.utils.StructParser(newParameters) ...
                .checkField('spacialDim', 'scalar', 'integer', 'positive') ...
                .checkField('masses', 'finite') ...
                .checkField('gravitationalConstant', 'scalar', 'real', 'finite', 'positive') ...
                .checkField('softeningLength', 'scalar', 'real', 'finite', 'nonnegative');
        end
        
        function sol = internalSolve(obj, varargin)
            sol = internalSolve@otp.Problem(obj, 'Method', @ode23t, varargin{:});
        end
        
        function mov = internalMovie(obj, t, y, varargin)
            mov = otp.utils.movie.NBodyMovie(obj.Name, obj.Parameters.spacialDim, varargin{:});
            mov.record(t, y(:, 1:end/2));
        end
    end
end
