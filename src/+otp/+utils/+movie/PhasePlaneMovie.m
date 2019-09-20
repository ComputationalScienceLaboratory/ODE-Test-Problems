classdef PhasePlaneMovie < otp.utils.movie.Movie
    properties (SetAccess = immutable, GetAccess = protected)
        MovieTitle
        MovieLabel
    end
    
    properties (Access = protected)
        AnimatedLine
    end
    
    methods
        function obj = PhasePlaneMovie(title, label, varargin)
            obj@otp.utils.movie.Movie(varargin{:});
            obj.MovieTitle = title;
            obj.MovieLabel = label;
        end
    end
    
    methods (Access = protected)
        function init(obj, fig, state)
            if state.numVars < 2 || state.numVars > 3
                error('Phase plane movie must be 2D or 3D');
            end
            
            ax = axes(fig);
            
            otp.utils.FancyPlot.axisLimits('x', state.y(:, 1));
            xlabel(ax, obj.MovieLabel(1));
            
            otp.utils.FancyPlot.axisLimits('y', state.y(:, 2));
            ylabel(ax, obj.MovieLabel(2));
            
            if state.numVars == 3
                otp.utils.FancyPlot.axisLimits('z', state.y(:, 3));
                zlabel(ax, obj.MovieLabel(3));
                view(ax, [45, 45]);
            end
            
            obj.AnimatedLine = animatedline(ax, 'Color', otp.utils.FancyPlot.color(1));
        end
        
        function drawFrame(obj, fig, state)
            title(fig.CurrentAxes, sprintf('%s at t=%g', obj.MovieTitle, state.tCur));
            if state.numVars == 2
                obj.AnimatedLine.addpoints(state.y(state.stepRange, 1), state.y(state.stepRange, 2));
            else
                obj.AnimatedLine.addpoints(state.y(state.stepRange, 1), state.y(state.stepRange, 2), ...
                    state.y(state.stepRange, 3));
            end
        end
    end
end
