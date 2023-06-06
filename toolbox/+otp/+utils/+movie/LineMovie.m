classdef LineMovie < otp.utils.movie.FancyMovie
    methods
        function obj = LineMovie(varargin)
            obj@otp.utils.movie.FancyMovie('xlabel', 'Variable Index', 'ylabel', 'y', 'linestyleorder', '*-', ...
                varargin{:});
        end
    end
    
    methods (Access = protected)
        function gObjects = initAxes(~, ax, state)
            otp.utils.FancyPlot.axisLimits(ax, 'x', [1, state.numVars]);
            otp.utils.FancyPlot.axisLimits(ax, 'y', state.y);
            gObjects = line(ax, 1:state.numVars, zeros(1, state.numVars));
        end
        
        function drawFrameAxes(~, ~, gObjects, state)
            set(gObjects, 'YData', state.yCur);
        end
    end
end

