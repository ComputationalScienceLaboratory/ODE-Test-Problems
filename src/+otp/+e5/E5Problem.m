classdef E5Problem < otp.Problem
    methods
        function obj = E5Problem(timeSpan, y0, parameters)
            obj@otp.Problem('E5', 4, timeSpan, y0, parameters);
        end
    end
    
    methods (Access=protected)        
        function onSettingsChanged(obj)
            A = obj.Parameters.A;
            B = obj.Parameters.B;
            C = obj.Parameters.C;
            M = obj.Parameters.M;
            
            obj.RHS = otp.RHS(@(t, y) otp.e5.f(t, y, A, B, C, M), ...
                'Jacobian', @(t, y) otp.e5.jacobian(t, y, A, B, C, M), ...
                'NonNegative', 1:obj.NumVars);
        end
        
        function fig = internalPlot(obj, t, y, varargin)
            fig = internalPlot@otp.Problem(obj, t, y, ...
                'xscale', 'log', 'yscale', 'log', varargin{:});
        end
        
        function mov = internalMovie(obj, t, y, varargin)
            mov = internalMovie@otp.Problem(obj, t, y, ...
                'xscale', 'log', 'yscale', 'log', varargin{:});
        end
        
        function sol = internalSolve(obj, varargin)
            % Set tolerances due to the very small scales
            sol = internalSolve@otp.Problem(obj, ...
                'AbsTol', 1e-50, varargin{:});
        end
    end
end
