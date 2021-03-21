classdef BouncingBallProblem < otp.Problem
    methods
        function obj = BouncingBallProblem(timeSpan, y0, parameters)
            obj@otp.Problem('Bouncing Ball', 4, timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            g   = obj.Parameters.g;
            gF  = obj.Parameters.groundFunction;
            dgF = obj.Parameters.dgroundFunction;
            
            obj.Rhs = otp.Rhs(@(t, y) otp.bouncingball.f(t, y, g, gF, dgF), ...
                otp.Rhs.FieldNames.Jacobian, @(t, y) otp.bouncingball.jac(t, y, g, gF, dgF), ...
                otp.Rhs.FieldNames.Events, @(t, y) otp.bouncingball.events(t, y, g, gF, dgF), ...
                otp.Rhs.FieldNames.OnEvent, @otp.bouncingball.onevent);
        end
        
        function validateNewState(obj, newTimeSpan, newY0, newParameters)
            validateNewState@otp.Problem(obj, newTimeSpan, newY0, newParameters);
            
            otp.utils.StructParser(newParameters) ...
                .checkField('g', 'scalar', 'finite') ...
                .checkField('groundFunction', 'function') ...
                .checkField('dgroundFunction', 'function');
        end
        
        function label = internalIndex2label(~, index)
            switch index
                case 1
                    label = 'x position';
                case 2
                    label = 'y position';
                case 3
                    label = 'x velocity';
                case 4
                    label = 'y velocity';
            end
        end
        
        function mov = internalMovie(obj, t, y, varargin)
            mov = otp.bouncingball.BouncingBallMovie(obj.Parameters.groundFunction, 'Title', obj.Name, varargin{:});
            mov.record(t, y);
        end
        
        function sol = internalSolve(obj, varargin)
            sol = internalSolve@otp.Problem(obj, 'Method', @ode45, varargin{:});
        end
    end
end

