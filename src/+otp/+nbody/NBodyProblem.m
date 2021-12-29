classdef NBodyProblem < otp.Problem
    methods
        function obj = NBodyProblem(timeSpan, y0, parameters)
            obj@otp.Problem('N-Body Problem', [], timeSpan, y0, parameters);
        end
    end
    
    methods(Access=protected)
        function onSettingsChanged(obj)
            spatialDim = obj.Parameters.spatialDim;
            masses = obj.Parameters.masses;
            g = obj.Parameters.gravitationalConstant;
            softeningLength = obj.Parameters.softeningLength;
            
            obj.Rhs = otp.Rhs(@(t, y) otp.nbody.f(t, y, spatialDim, masses, g, softeningLength));
        end
        
        function validateNewState(obj, newTimeSpan, newY0, newParameters)
            validateNewState@otp.Problem(obj, newTimeSpan, newY0, newParameters);
            
            otp.utils.StructParser(newParameters) ...
                .checkField('spatialDim', 'scalar', 'integer', 'positive') ...
                .checkField('masses', 'finite') ...
                .checkField('gravitationalConstant', 'scalar', 'real', 'finite', 'positive') ...
                .checkField('softeningLength', 'scalar', 'real', 'finite', 'nonnegative');
        end
        
        function sol = internalSolve(obj, varargin)
            sol = internalSolve@otp.Problem(obj, 'Method', @ode15s, varargin{:});
        end
        
        function mov = internalMovie(obj, t, y, varargin)
            mov = otp.utils.movie.PhaseSpaceMovie('Title', obj.Name, ...
                'xlabel', 'x', 'ylabel', 'y', 'zlabel', 'z', ...
                'Vars', reshape(1:obj.NumVars / 2, obj.Parameters.spatialDim, []).', varargin{:});
            mov.record(t, y);
        end
    end
end
