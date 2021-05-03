classdef LotkaVolterraProblem < otp.Problem

    methods
        function obj = LotkaVolterraProblem(timeSpan, y0, parameters)
            % Constructs a problem
            obj@otp.Problem('Lotka-Volterra', 2, timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            
            preyBirthRate     = obj.Parameters.preyBirthRate;
            preyDeathRate     = obj.Parameters.preyDeathRate;
            predatorDeathRate = obj.Parameters.predatorDeathRate; 
            predatorBirthRate = obj.Parameters.predatorBirthRate; 
            
            obj.Rhs = otp.Rhs(@(t, y) otp.lotkavolterra.f(t, y, preyBirthRate, preyDeathRate, predatorDeathRate, predatorBirthRate), ...
                otp.Rhs.FieldNames.Jacobian, ...
                @(t, y) otp.lotkavolterra.jac(t, y, preyBirthRate, preyDeathRate, predatorDeathRate, predatorBirthRate), ...
                otp.Rhs.FieldNames.Vectorized, 'on');
            
        end
        
        function validateNewState(obj, newTimeSpan, newY0, newParameters)
            
            validateNewState@otp.Problem(obj, newTimeSpan, newY0, newParameters)
            
            otp.utils.StructParser(newParameters) ...
                .checkField('preyBirthRate',     'scalar', 'real', 'finite', 'positive') ...
                .checkField('preyDeathRate',     'scalar', 'real', 'finite', 'positive') ...
                .checkField('predatorDeathRate', 'scalar', 'real', 'finite', 'positive') ...
                .checkField('predatorBirthRate', 'scalar', 'real', 'finite', 'positive');
            
        end
        
        function label = internalIndex2label(~, index)
            
            if index == 1
                label = 'Prey';
            else
                label = 'Predator';
            end
            
        end
        
        function sol = internalSolve(obj, varargin)
            
            sol = internalSolve@otp.Problem(obj, 'Method', @ode45, varargin{:});
            
        end
    end
end
