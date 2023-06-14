classdef BouncingBallMovie < otp.utils.movie.CometMovie
    properties (SetAccess = immutable, GetAccess = private)
        Ground
    end
    
    methods
        function obj = BouncingBallMovie(ground, varargin)
            obj@otp.utils.movie.CometMovie(otp.utils.PhysicalConstants.TwoD, 'xlabel', 'x', 'ylabel', 'y', varargin{:});
            obj.Ground = ground;
        end
    end
    
    methods (Access = protected)
        function gObjects = initAxes(obj, ax, state)
            gObjects = initAxes@otp.utils.movie.CometMovie(obj, ax, state);
            
            otp.utils.FancyPlot.axisLimits(ax, 'x', state.y(1, :));            
            groundX = linspace(ax.XLim(1), ax.XLim(2));
            groundY = arrayfun(obj.Ground, groundX);
            line(ax, groundX, groundY, 'Color', 'k', 'LineWidth', 1.5);
            
            otp.utils.FancyPlot.axisLimits(ax, 'y', [state.y(2, :), groundY]);
        end
        
        function numComets = getNumComets(~, ~)
            numComets = 1;
        end
        
        function x = getXPoints(~, ~, state)
            x = state.y(1, state.stepRange);
        end
        
        function y = getYPoints(~, ~, state)
            y = state.y(2, state.stepRange);
        end
    end
end

