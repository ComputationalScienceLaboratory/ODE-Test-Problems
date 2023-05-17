classdef SimpleProblem < otp.Problem
    methods
        function obj = SimpleProblem(timeSpan, y0, parameters)
            obj@otp.Problem('New Test Problem', [], timeSpan, y0, parameters);
        end
    end

    methods (Access=protected)
        function onSettingsChanged(obj)
            param1 = obj.Parameters.param1;
            obj.RHS = otp.RHS(@(t, y) otp.newtest.f(t, y, param1));
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
