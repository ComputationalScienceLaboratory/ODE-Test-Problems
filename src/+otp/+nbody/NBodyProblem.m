classdef NBodyProblem < otp.Problem
    methods
        function obj = NBodyProblem(timeSpan, y0, parameters)
            obj@otp.Problem('N-Body Problem', [], timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function validateNewState(obj, newTimeSpan, newY0, newParameters)
            validateNewState@otp.Problem(obj, newTimeSpan, newY0, ...
                newParameters);
            
            numMasses = length(newParameters.Masses);
            expectedLen = 2 * numMasses * newParameters.SpatialDim;
            actualLen = length(newY0);
            
            if expectedLen ~= actualLen
                warning('OTP:inconsistentNumVars', ...
                    'With %d masses, NumVars should be %d but is %d', ...
                    numMasses, expectedLen, actualLen);
            end
        end
        
        function onSettingsChanged(obj)
            spatialDim = obj.Parameters.SpatialDim;
            masses = obj.Parameters.Masses;
            gravitationalConstant = obj.Parameters.GravitationalConstant;
            softeningLength = obj.Parameters.SofteningLength;
            
            obj.RHS = otp.RHS(@(t, y) otp.nbody.f(t, y, spatialDim, masses, gravitationalConstant, softeningLength));
        end
        
        function sol = internalSolve(obj, varargin)
            sol = internalSolve@otp.Problem(obj, 'Solver', otp.utils.Solver.Symplectic, varargin{:});
        end
        
        function mov = internalMovie(obj, t, y, varargin)
            mov = otp.utils.movie.PhaseSpaceMovie('Title', obj.Name, ...
                'xlabel', 'x', 'ylabel', 'y', 'zlabel', 'z', ...
                'Vars', reshape(1:obj.NumVars / 2, obj.Parameters.spatialDim, []).', varargin{:});
            mov.record(t, y);
        end
    end
end
