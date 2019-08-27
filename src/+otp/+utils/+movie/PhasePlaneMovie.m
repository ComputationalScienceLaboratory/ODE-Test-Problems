classdef PhasePlaneMovie < otp.utils.movie.Movie
    properties (SetAccess = immutable, GetAccess = protected)
        problem
        dim
        indices
    end
    
    properties (Access = private)
        animatedLine
    end
    
    methods
        function obj = PhasePlaneMovie(problem, indices, varargin)
            obj@otp.utils.movie.Movie(varargin{:});
            obj.problem = problem;
            obj.dim = length(indices);
            if obj.dim < 2 || obj.dim > 3
                error('Phase plane movie must be 2D or 3D');
            end
            obj.indices = indices;
        end
    end
    
    methods (Access = protected)
        function init(obj, fig, state)
            ax = axes(fig);
            
            i = obj.indices(1);
            xlim(otp.utils.FancyPlot.axisLimits(state.y(:, i)));
            xlabel(ax, obj.problem.index2label(i));
            
            i = obj.indices(2);
            ylim(otp.utils.FancyPlot.axisLimits(state.y(:, i)));
            ylabel(ax, obj.problem.index2label(i));
            
            if obj.dim == 3
                i = obj.indices(3);
                zlim(otp.utils.FancyPlot.axisLimits(state.y(:, i)));
                zlabel(ax, obj.problem.index2label(i));
                view(ax, [45, 45]);
            end
            
            obj.animatedLine = animatedline(ax, 'Color', otp.utils.FancyPlot.color(1));
        end
        
        function drawFrame(obj, fig, state)
            title(fig.CurrentAxes, sprintf('%s at t=%g', obj.problem.Name, state.tCur));
            x = state.y(state.stepRange, obj.indices(1));
            y = state.y(state.stepRange, obj.indices(2));
            if obj.dim == 2
                obj.animatedLine.addpoints(x, y);
            else
                obj.animatedLine.addpoints(x, y, state.y(state.stepRange, obj.indices(3)));
            end
        end
    end
end
    
