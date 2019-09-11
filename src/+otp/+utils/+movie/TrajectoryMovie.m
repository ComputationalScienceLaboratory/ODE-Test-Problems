classdef TrajectoryMovie < otp.utils.movie.Movie
    properties (SetAccess = immutable, GetAccess = protected)
        MovieTitle
        MovieLegend
    end
    
    properties (Access = private)
        AnimatedLines
    end
    
    methods
        function obj = TrajectoryMovie(title, legend, varargin)
            obj@otp.utils.movie.Movie(varargin{:});
            obj.MovieTitle = title;
            obj.MovieLegend = legend;
        end
    end
       
    methods (Access = protected)
        function init(obj, fig, state)
            ax = axes(fig);
            xlim(otp.utils.FancyPlot.axisLimits(state.t, 0));
            ylim(otp.utils.FancyPlot.axisLimits(state.y));
            
            obj.AnimatedLines = gobjects(state.numVars, 1);
            for i = 1:state.numVars
                obj.AnimatedLines(i) = animatedline(ax, 'Color', otp.utils.FancyPlot.color(state.numVars, i));
            end
            
            xlabel(ax, 't');
            ylabel(ax, 'y');
            otp.utils.FancyPlot.legend(ax, 'Legend', obj.MovieLegend);
        end
        
        function drawFrame(obj, fig, state)
            title(fig.CurrentAxes, sprintf('%s at t=%g', obj.MovieTitle, state.tCur));
            for i = 1:state.numVars
                obj.AnimatedLines(i).addpoints(state.t(state.stepRange), state.y(state.stepRange, i));
            end
        end
    end
end

