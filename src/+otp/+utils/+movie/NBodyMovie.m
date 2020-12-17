classdef NBodyMovie < otp.utils.movie.Movie
    properties (SetAccess = immutable, GetAccess = protected)
        MovieTitle
        MovieLabels
        MovieLegend
    end
    
    properties (Access = protected)
        AnimatedLines
        Heads
    end
    
    methods
        function obj = NBodyMovie(title, labels, legend, varargin)
            obj@otp.utils.movie.Movie(varargin{:});
            obj.MovieTitle = title;
            obj.MovieLabels = labels;
            obj.Legend = legend;
        end
    end
    
    methods (Access = protected)
        function init(obj, fig, state)
            ax = axes(fig);
            
            otp.utils.FancyPlot.axisLimits('x', state.y(:, 1:obj.Dim:end));
            xlabel(ax, 'x');
            
            otp.utils.FancyPlot.axisLimits('y', state.y(:, 2:obj.Dim:end));
            ylabel(ax, 'y');
            
            if obj.Dim == 3
                otp.utils.FancyPlot.axisLimits('z', state.y(:, 3:obj.Dim:end));
                zlabel(ax, 'z');
                view(ax, [45, 45]);
            end
            
            obj.AnimatedLines = gobjects(state.numVars, 1);
            obj.Heads = gobjects(state.numVars, 1);
            bodies = state.numVars / obj.Dim;
            for i = 1:bodies
                color = otp.utils.FancyPlot.color(bodies, i);
                obj.AnimatedLines(i) = animatedline(ax, 'Color', otp.utils.FancyPlot.brighten(color, 0.9));
                obj.Heads(i) = line(ax, 'Color', 'k', 'MarkerFaceColor', color, 'MarkerSize', 7, 'Marker', 'o', ...
                    'LineStyle', 'none', 'XData', 0, 'YData', 0);
            end
        end
        
        function drawFrame(obj, fig, state)
            title(fig.CurrentAxes, sprintf('%s at t=%g', obj.MovieTitle, state.tCur));
            
            bodies = state.numVars / obj.Dim;
            for i = 1:bodies
                xi = obj.Dim * (i - 1) + 1;
                yi = obj.Dim * (i - 1) + 2;
                if obj.Dim == 2
                    obj.AnimatedLines(i).addpoints(state.y(state.stepRange, xi), state.y(state.stepRange, yi));
                    set(obj.Heads(i), 'XData', state.yCur(xi), 'YData', state.yCur(yi));
                else
                    zi = obj.Dim * i;
                    obj.AnimatedLines(i).addpoints(state.y(state.stepRange, xi), state.y(state.stepRange, yi), ...
                        state.y(state.stepRange, zi));
                    set(obj.Heads(i), 'XData', state.yCur(xi), 'YData', state.yCur(yi), 'ZData', state.yCur(zi));
                end
            end
        end
    end
end
