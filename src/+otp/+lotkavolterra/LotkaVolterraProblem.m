classdef LotkaVolterraProblem < otp.Problem

    methods
        function obj = LotkaVolterraProblem(timeSpan, y0, parameters)
            % Constructs a problem
            obj@otp.Problem('Lotka-Volterra', 2, timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            
            preyBirthRate     = obj.Parameters.PreyBirthRate;
            preyDeathRate     = obj.Parameters.PreyDeathRate;
            predatorDeathRate = obj.Parameters.PredatorDeathRate; 
            predatorBirthRate = obj.Parameters.PredatorBirthRate; 
            
            obj.RHS = otp.RHS(@(t, y) otp.lotkavolterra.f(t, y, preyBirthRate, preyDeathRate, predatorDeathRate, predatorBirthRate), ...
                'Jacobian', ...
                @(t, y) otp.lotkavolterra.jacobian(t, y, preyBirthRate, preyDeathRate, predatorDeathRate, predatorBirthRate), ...
                'Vectorized', 'on');
            
        end

        function label = internalIndex2label(~, index)
            
            if index == 1
                label = 'Prey';
            else
                label = 'Predator';
            end
            
        end
        
        function sol = internalSolve(obj, varargin)
            
            sol = internalSolve@otp.Problem(obj, 'Solver', otp.utils.Solver.Nonstiff, varargin{:});
            
        end
    end
end
