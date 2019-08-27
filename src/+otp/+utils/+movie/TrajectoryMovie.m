classdef TrajectoryMovie < otp.utils.movie.Movie
    properties (SetAccess = immutable, GetAccess = protected)
        problem
    end
    
    properties (Access = private)
        animatedLines
    end
    
    methods
        function obj = TrajectoryMovie(problem, varargin)
            obj@otp.utils.movie.Movie(varargin{:});
            obj.problem = problem;
        end
    end
       
    methods (Access = protected)
        function init(obj, fig, state)
            ax = axes(fig);
            xlim(otp.utils.FancyPlot.axisLimits(state.t, 0));
            ylim(otp.utils.FancyPlot.axisLimits(state.y));
            
            obj.animatedLines = gobjects(state.numVars, 1);
            for i = 1:state.numVars
                obj.animatedLines(i) = animatedline(ax, 'Color', otp.utils.FancyPlot.color(state.numVars, i));
            end
            
            xlabel(ax, 't');
            ylabel(ax, 'y');
            p = obj.problem;
            otp.utils.FancyPlot.legend(ax, 'Legend', @p.index2label);
        end
        
        function drawFrame(obj, fig, state)
            title(fig.CurrentAxes, sprintf('%s at t=%g', obj.problem.Name, state.tCur));
            for i = 1:state.numVars
                obj.animatedLines(i).addpoints(state.t(state.stepRange), state.y(state.stepRange, i));
            end
        end
    end
end

