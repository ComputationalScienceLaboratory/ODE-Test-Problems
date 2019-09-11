classdef PhasePlaneMovie < otp.utils.movie.Movie
    properties (SetAccess = immutable, GetAccess = protected)
        MovieTitle
        MovieLabel
        Dim
        Indices
    end
    
    properties (Access = private)
        AnimatedLine
    end
    
    methods
        function obj = PhasePlaneMovie(title, label, indices, varargin)
            obj@otp.utils.movie.Movie(varargin{:});
            obj.MovieTitle = title;
            obj.MovieLabel = label;
            obj.Dim = length(indices);
            if obj.Dim < 2 || obj.Dim > 3
                error('Phase plane movie must be 2D or 3D');
            end
            obj.Indices = indices;
        end
    end
    
    methods (Access = protected)
        function init(obj, fig, state)
            ax = axes(fig);
            
            i = obj.Indices(1);
            xlim(otp.utils.FancyPlot.axisLimits(state.y(:, i)));
            xlabel(ax, obj.MovieLabel(1));
            
            i = obj.Indices(2);
            ylim(otp.utils.FancyPlot.axisLimits(state.y(:, i)));
            ylabel(ax, obj.MovieLabel(2));
            
            if obj.Dim == 3
                i = obj.Indices(3);
                zlim(otp.utils.FancyPlot.axisLimits(state.y(:, i)));
                zlabel(ax, obj.MovieLabel(3));
                view(ax, [45, 45]);
            end
            
            obj.AnimatedLine = animatedline(ax, 'Color', otp.utils.FancyPlot.color(1));
        end
        
        function drawFrame(obj, fig, state)
            title(fig.CurrentAxes, sprintf('%s at t=%g', obj.MovieTitle, state.tCur));
            x = state.y(state.stepRange, obj.Indices(1));
            y = state.y(state.stepRange, obj.Indices(2));
            if obj.Dim == 2
                obj.AnimatedLine.addpoints(x, y);
            else
                obj.AnimatedLine.addpoints(x, y, state.y(state.stepRange, obj.Indices(3)));
            end
        end
    end
end
    
