classdef PhaseSpaceMovie < otp.utils.movie.CometMovie
    
    properties (SetAccess = immutable, GetAccess = private)
        Vars
    end
    
    methods
        function obj = PhaseSpaceMovie(varargin)
            p = inputParser;
            p.KeepUnmatched = true;
            p.addParameter('Vars', 1:otp.utils.PhysicalConstants.TwoD, @ismatrix);
            p.parse(varargin{:});
            vars = p.Results.Vars;
            
            obj@otp.utils.movie.CometMovie(size(vars, 2), p.Unmatched);
            obj.Vars = vars;
        end
    end
    
    methods (Access = protected)
        function gObjects = initAxes(obj, ax, state)
            gObjects = initAxes@otp.utils.movie.CometMovie(obj, ax, state);
            
            otp.utils.FancyPlot.axisLimits(ax, 'x', state.y(obj.Vars(:, otp.utils.PhysicalConstants.OneD), :));
            otp.utils.FancyPlot.axisLimits(ax, 'y', state.y(obj.Vars(:, otp.utils.PhysicalConstants.TwoD), :));
            
            if obj.Dim == otp.utils.PhysicalConstants.ThreeD
                otp.utils.FancyPlot.axisLimits(ax, 'z', state.y(obj.Vars(:, otp.utils.PhysicalConstants.ThreeD), :));
            end
        end
        
        function numComets = getNumComets(obj, ~)
            numComets = size(obj.Vars, 1);
        end
        
        function x = getXPoints(obj, cometIdx, state)
            x = state.y(obj.Vars(cometIdx, otp.utils.PhysicalConstants.OneD), state.stepRange);
        end
        
        function y = getYPoints(obj, cometIdx, state)
            y = state.y(obj.Vars(cometIdx, otp.utils.PhysicalConstants.TwoD), state.stepRange);
        end
        
        function z = getZPoints(obj, cometIdx, state)
            z = state.y(obj.Vars(cometIdx, otp.utils.PhysicalConstants.ThreeD), state.stepRange);
        end
    end
end
