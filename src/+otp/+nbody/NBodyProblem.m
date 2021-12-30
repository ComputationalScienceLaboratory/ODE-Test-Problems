classdef NBodyProblem < otp.Problem
    methods
        function obj = NBodyProblem(timeSpan, y0, parameters)
            obj@otp.Problem('N-Body Problem', [], timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            spatialdim = obj.Parameters.SpatialDim;
            masses = obj.Parameters.Masses;
            gravitationalconstant = obj.Parameters.GravitationalConstant;
            softeninglength = obj.Parameters.SofteningLength;
            
            obj.Rhs = otp.Rhs(@(t, y) otp.nbody.f(t, y, spatialdim, masses, gravitationalconstant, softeninglength));
        end
        
        function sol = internalSolve(obj, varargin)
            sol = internalSolve@otp.Problem(obj, 'Method', @ode23t, varargin{:});
        end
        
        function mov = internalMovie(obj, t, y, varargin)
            mov = otp.utils.movie.PhaseSpaceMovie('Title', obj.Name, ...
                'xlabel', 'x', 'ylabel', 'y', 'zlabel', 'z', ...
                'Vars', reshape(1:obj.NumVars / 2, obj.Parameters.spatialDim, []).', varargin{:});
            mov.record(t, y);
        end
    end
end
