classdef TrajectoryMovie < otp.utils.movie.CometMovie
    
    methods
        function obj = TrajectoryMovie(varargin)
            obj@otp.utils.movie.CometMovie(otp.utils.PhysicalConstants.TwoD, 'xlabel', 't', 'ylabel', 'y', varargin{:});
        end
    end
    
    methods (Access = protected)
        function gObjects = initAxes(obj, ax, state)
            gObjects = initAxes@otp.utils.movie.CometMovie(obj, ax, state);
            
            otp.utils.FancyPlot.axisLimits(ax, 'x', state.t);
            otp.utils.FancyPlot.axisLimits(ax, 'y', state.y);
        end
        
        function x = getXPoints(~, ~, state)
            x = state.t(state.stepRange);
        end
        
        function y = getYPoints(~, cometIdx, state)
            y = state.y(cometIdx, state.stepRange);
        end
    end
end
