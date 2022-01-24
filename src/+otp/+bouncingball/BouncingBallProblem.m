classdef BouncingBallProblem < otp.Problem
    methods
        function obj = BouncingBallProblem(timeSpan, y0, parameters)
            obj@otp.Problem('Bouncing Ball', 4, timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            g           = obj.Parameters.Gravity;
            ground      = obj.Parameters.Ground;
            groundSlope = obj.Parameters.GroundSlope;
            
            obj.RHS = otp.RHS(@(t, y) otp.bouncingball.f(t, y, g, ground, groundSlope), ...
                'Jacobian', otp.bouncingball.jacobian(g, ground, groundSlope), ...
                'Events', @(t, y) otp.bouncingball.events(t, y, g, ground, groundSlope), ...
                'OnEvent', @otp.bouncingball.onEvent);
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
            mov = otp.bouncingball.BouncingBallMovie(obj.Parameters.ground, 'Title', obj.Name, varargin{:});
            mov.record(t, y);
        end
        
        function sol = internalSolve(obj, varargin)
            sol = internalSolve@otp.Problem(obj, 'Solver', otp.utils.Solver.Nonstiff, varargin{:});
        end
    end
end

