classdef TrajectoryMovie < otp.utils.movie.Movie
    properties (SetAccess = immutable, GetAccess = private)
        AxesConfig
    end
    
    properties (Access = private)
        AnimatedLines
    end
    
    methods
        function obj = TrajectoryMovie(varargin)
            p = inputParser;
            p.KeepUnmatched = true;
            otp.utils.FancyPlot.addAxesParameters(p);
            p.parse('xlabel', 't', 'ylabel', 'y', varargin{:});
            obj@otp.utils.movie.Movie(p.Unmatched);
            obj.AxesConfig = p.Results;
        end
    end
       
    methods (Access = protected)
        function init(obj, fig, state)
            ax = axes(fig);            
            obj.AnimatedLines = gobjects(state.numVars, 1);
            for i = 1:state.numVars
                obj.AnimatedLines(i) = animatedline(ax);
            end
            
            otp.utils.FancyPlot.axisLimits(ax, 'x', state.t, 0);
            otp.utils.FancyPlot.axisLimits(ax, 'y', state.y);
            otp.utils.FancyPlot.configureAxes(ax, obj.AnimatedLines, obj.AxesConfig);
        end
        
        function drawFrame(obj, fig, state)
            title(fig.CurrentAxes, sprintf('%s at t=%g', obj.AxesConfig.title, state.tCur));
            for i = 1:state.numVars
                obj.AnimatedLines(i).addpoints(state.t(state.stepRange), state.y(i, state.stepRange));
            end
        end
    end
end

