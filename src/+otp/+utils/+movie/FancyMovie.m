classdef (Abstract) FancyMovie < otp.utils.movie.Movie
    properties (SetAccess = immutable, GetAccess = private)
        AxesConfig
    end
    
    properties (Access = private)
        GObjects
    end
    
    methods
        function obj = FancyMovie(varargin)
            p = inputParser;
            p.KeepUnmatched = true;
            otp.utils.FancyPlot.addAxesParameters(p);
            p.parse(varargin{:});
            obj@otp.utils.movie.Movie(p.Unmatched);
            obj.AxesConfig = p.Results;
        end
        
        function configureAxes(obj, ax)
            otp.utils.FancyPlot.configureAxes(ax, obj.AxesConfig);
        end
    end
    
    methods (Access = protected, Sealed)
        function init(obj, fig, state)
            ax = axes(fig);
            obj.configureAxes(ax);
            obj.GObjects = obj.initAxes(ax, state);
            otp.utils.FancyPlot.configureLegend(ax, obj.GObjects, obj.AxesConfig);
        end
        
        function drawFrame(obj, fig, state)
            ax = fig.CurrentAxes;
            title(ax, sprintf('%s at t=%.3e', obj.AxesConfig.title, state.tCur));
            obj.drawFrameAxes(ax, obj.GObjects, state);
        end
    end
    
    methods (Access = protected, Abstract)
        gObjects = initAxes(obj, ax, state);
        drawFrameAxes(obj, ax, gObjects, state);
    end
end
