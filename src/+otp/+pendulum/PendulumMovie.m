classdef PendulumMovie < otp.utils.movie.FancyMovie
    methods
        function obj = PendulumMovie(varargin)
            obj@otp.utils.movie.FancyMovie('xlabel', 'x', 'ylabel', 'y', 'linestyleorder', 'O-', ...
                varargin{:});
        end
    end
    
    methods (Access = protected)
        function gObjects = initAxes(~, ax, state)
            otp.utils.FancyPlot.axisLimits(ax, 'x', state.y(1:end/2, :));
            otp.utils.FancyPlot.axisLimits(ax, 'y', state.y(end/2+1:end, :));
            z = zeros(state.numVars / 2 + 1, 1);
            gObjects = line(ax, z, z);
        end
        
        function drawFrameAxes(~, ~, gObjects, state)
            gObjects.XData = state.yCur(1:end/2);
            gObjects.YData = state.yCur(end/2+1:end);
        end
    end
end
