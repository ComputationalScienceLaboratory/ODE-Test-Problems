classdef LineMovie < otp.utils.movie.Movie
    properties (SetAccess = immutable, GetAccess = protected)
        MovieTitle
        MovieXLabel
        MovieYLabel
    end
    
    methods
        function obj = LineMovie(title, xlabel, ylabel, varargin)
            obj@otp.utils.movie.Movie(varargin{:});
            obj.MovieTitle = title;
            obj.MovieXLabel = xlabel;
            obj.MovieYLabel = ylabel;
        end
    end
       
    methods (Access = protected)
        function init(obj, fig, state)
            ax = axes(fig);
            ax.NextPlot = 'replaceChildren';
            xlabel(ax, obj.MovieXLabel);
            ylabel(ax, obj.MovieYLabel);
            ylim(otp.utils.FancyPlot.axisLimits(state.y));
        end
        
        function drawFrame(obj, fig, state)
            ax = fig.CurrentAxes;
            title(ax, sprintf('%s at t=%g', obj.MovieTitle, state.tCur));
            plot(ax, state.yCur, 'o-');
        end
    end
end

