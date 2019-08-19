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
            [t0, tEnd] = bounds(state.t);
            tRange = tEnd - t0;
            [yMin, yMax] = bounds(state.y, 'all');
            yRange = yMax - yMin;
            axis(ax, [t0 - 0.1 * tRange, tEnd + 0.1 * tRange, yMin - 0.1 * yRange, yMax + 0.1 * yRange]);
            
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

