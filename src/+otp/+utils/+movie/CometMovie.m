classdef (Abstract) CometMovie < otp.utils.movie.FancyMovie
    
    properties (Access = protected)
        Dim
    end
    
    methods
        function obj = CometMovie(dim, varargin)
            if dim < otp.utils.PhysicalConstants.TwoD || dim > otp.utils.PhysicalConstants.ThreeD
                error('Cannot make a %dD comet movie', dim);
            end
            
            obj@otp.utils.movie.FancyMovie('View', dim, varargin{:});
            obj.Dim = dim;
        end
    end
    
    methods (Access = protected)
        function gObjects = initAxes(obj, ax, state)
            numComets = obj.getNumComets(state);
            gObjects.lines = arrayfun(@(~) animatedline(ax), 1:numComets);
            gObjects.heads = line(ax, zeros(numComets, 1), 0, 0, 'Marker', 'o', 'LineStyle', 'none');
            for i = 1:numComets
                c = gObjects.heads(i).Color;
                gObjects.heads(i).MarkerFaceColor = c;
                gObjects.lines(i).Color = otp.utils.FancyPlot.lighten(c, 0.6);
            end
        end
        
        function drawFrameAxes(obj, ~, gObjects, state)
            for i = 1:length(gObjects.heads)
                x = obj.getXPoints(i, state);
                if isempty(x)
                    return;
                end
                
                y = obj.getYPoints(i, state);
                
                head = gObjects.heads(i);
                head.XData = x(end);
                head.YData = y(end);
                
                if obj.Dim == otp.utils.PhysicalConstants.TwoD
                    gObjects.lines(i).addpoints(x, y);
                else
                    z = obj.getZPoints(i, state);
                    head.ZData = z(end);
                    gObjects.lines(i).addpoints(x, y, z);
                end
            end
        end
        
        function numComets = getNumComets(~, state)
            numComets = state.numVars;
        end
        
        function z = getZPoints(~, ~, ~)
            z = '3D trajectory not supported';
            error(z);
        end
    end
    
    methods (Access = protected)
        function x = getXPoints(obj, cometIdx, state)
            x = otp.utils.compatibility.abstract(obj, cometIdx, state);
        end
        
        function y = getYPoints(obj, cometIdx, state)
            y = otp.utils.compatibility.abstract(obj, cometIdx, state);           
        end
    end
end
