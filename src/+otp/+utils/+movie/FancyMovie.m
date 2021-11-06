classdef (Abstract) FancyMovie < otp.utils.movie.Movie
    properties (Access = private)
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
    end
    
    methods (Access = protected, Sealed)
        function init(obj, fig, state)
            ax = axes(fig);
            otp.utils.FancyPlot.configureAxes(ax, obj.AxesConfig);
            obj.GObjects = obj.initAxes(ax, state);
            otp.utils.FancyPlot.configureLegend(ax, obj.GObjects, obj.AxesConfig);
        end
        
        function drawFrame(obj, fig, state)
            ax = get(fig, 'CurrentAxes');
            title(ax, sprintf('%s at t=%.3e', obj.AxesConfig.title, state.tCur));
            obj.drawFrameAxes(ax, obj.GObjects, state);
        end
    end
    
    methods (Access = protected)
        function gObjects = initAxes(obj, ax, state)
            gObjects = otp.utils.compatibility.abstract(obj, ax, state);
        end
        
        function drawFrameAxes(obj, ax, gObjects, state)
            otp.utils.compatibility.abstract(obj, ax, gObjects, state);
        end
    end
end
