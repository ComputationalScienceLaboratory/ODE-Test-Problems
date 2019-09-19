classdef BouncingBallMovie < otp.utils.movie.Movie
    properties (SetAccess = immutable, GetAccess = private)
        MovieTitle
        GroundFunction
    end
    
    properties (Access = private)
        AnimatedLine
        Head
    end
    
    methods
        function obj = BouncingBallMovie(title, groundFunction, varargin)
            obj@otp.utils.movie.Movie(varargin{:});
            obj.MovieTitle = title;
            obj.GroundFunction = groundFunction;
        end
    end
       
    methods (Access = protected)
        function init(obj, fig, state)
            ax = axes(fig);
            xlabel(ax, 'x');
            ylabel(ax, 'y');
            
            xLim = otp.utils.FancyPlot.axisLimits(state.y(:, 1));
            
            groundX = linspace(xLim(1), xLim(2), 1024).';
            groundY = arrayfun(@(x) obj.GroundFunction(x), groundX);
            plot(ax, groundX, groundY, 'k');
            
            xlim(xLim);
            ylim(otp.utils.FancyPlot.axisLimits([state.y(:, 2); groundY]));
            
            color = otp.utils.FancyPlot.color(1);
            obj.AnimatedLine = animatedline(ax, 'Color', otp.utils.FancyPlot.brighten(color, 0.9));
            obj.Head = line(ax, 'Color', 'k', 'MarkerFaceColor', color, 'MarkerSize', 7, 'Marker', 'o', ...
                'LineStyle', 'none', 'XData', 0, 'YData', 0);
        end
        
        function drawFrame(obj, fig, state)
            title(fig.CurrentAxes, sprintf('%s at t=%g', obj.MovieTitle, state.tCur));
            obj.AnimatedLine.addpoints(state.y(state.stepRange, 1), state.y(state.stepRange, 2));
            set(obj.Head, 'XData', state.yCur(1), 'YData', state.yCur(2));
        end
    end
end

