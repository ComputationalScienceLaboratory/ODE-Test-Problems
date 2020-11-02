classdef PendulumMovie < otp.utils.movie.Movie
    properties (SetAccess = immutable, GetAccess = private)
        MovieTitle
    end
    
    methods
        function obj = PendulumMovie(title, varargin)
            obj@otp.utils.movie.Movie(varargin{:});
            obj.MovieTitle = title;
        end
    end
    
    methods (Access = protected)
        function init(obj, fig, state)
            ax = axes(fig);
            ax.NextPlot = 'replaceChildren';
            xlabel(ax, 'x');
            ylabel(ax, 'y');
            
            b = max(abs(state.y), [], 'all');
            obj.Bounds = otp.utils.FancyPlot.axisLimits(ax, 'xy', [-b, b]);
            axis(ax, 'square');
        end
        
        function drawFrame(obj, fig, state)
            ax = fig.CurrentAxes;
            title(ax, sprintf('%s at t=%g', obj.MovieTitle, state.tCur));
            plot(ax, [0, state.yCur(1:end/2)], [0, state.yCur((end/2+1):end)], 'O-');
        end
    end
end

