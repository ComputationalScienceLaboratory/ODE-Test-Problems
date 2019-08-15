classdef (Sealed) FancyPlot
    
    methods (Static)
        function c = color(m, n)
            if nargin == 1
                h = linspace(0, 1 - 1 / m, m)';
                s = 0.8 * ones(m, 1);
            else
                h = (n - 1) / m;
                s = 0.8;
            end
            
            c = hsv2rgb([h, s, s]);
        end
        
        function legend(ax, varargin)
            n = length(ax.Children);
            p = inputParser;
            otp.utils.FancyPlot.addLegendParams(p, n);
            p.parse(varargin{:});
            otp.utils.FancyPlot.useLegendParams(ax, n, p.Results);
        end
        
        function h = plot(ax, x, y, varargin)
            n = size(y, 2);
            
            p = inputParser;
            p.addOptional('z', []);
            p.addParameter('plotter', []);
            p.addParameter('linespec', '-');
            otp.utils.FancyPlot.addStyleParams(p);
            otp.utils.FancyPlot.addLegendParams(p, n);
            p.parse(varargin{:});
            config = p.Results;
            
            hold(ax, 'all');
            ax.ColorOrder = otp.utils.FancyPlot.color(n);
            ax.LineStyleOrder = config.linespec;
            
            if isempty(config.z)
                if isempty(config.plotter)
                    h = plot(ax, x, y);
                else
                    h = config.plotter(ax, x, y);
                end
            else
                if isempty(config.plotter)
                    h = plot3(ax, x, y, config.z);
                else
                    h = config.plotter(ax, x, y, config.z);
                end
            end
            
            otp.utils.FancyPlot.useStyleParams(ax, config);
            otp.utils.FancyPlot.useLegendParams(ax, n, config);
            
            hold(ax, 'off');
        end
        
        function h = bar(ax, x, y, varargin)
            p = inputParser;
            otp.utils.FancyPlot.addStyleParams(p);
            p.parse(varargin{:});
            config = p.Results;
            
            h = bar(ax, x, y);
            otp.utils.FancyPlot.useStyleParams(ax, config);
            h.FaceColor = 'flat';
            h.CData = otp.utils.FancyPlot.color(size(y, 2));
        end
    end
    
    methods (Access = private, Static)
        function setPlotFunctions(ax, config, varargin)
            for i = 1:length(varargin)
                func = varargin{i};
                val = config.(func2str(func));
                if ~isempty(val)
                    func(ax, val);
                end
            end
        end
        
        function setPlotProps(ax, config, varargin)
            for i = 1:length(varargin)
                prop = varargin{i};
                val = config.(prop);
                if ~isempty(val)
                    set(ax, prop, val);
                end
            end
        end
        
        function addStyleParams(p)
            p.addParameter('title', []);
            p.addParameter('xlabel', []);
            p.addParameter('ylabel', []);
            p.addParameter('zlabel', []);
            p.addParameter('view', []);
            p.addParameter('axislimits', []);
            p.addParameter('axisstyle', []);
            p.addParameter('axisdirection', []);
            p.addParameter('axisvisibility', []);
            p.addParameter('xscale', []);
            p.addParameter('yscale', []);
            p.addParameter('zscale', []);
        end
        
        function useStyleParams(ax, config)
            otp.utils.FancyPlot.setPlotFunctions(ax, config, @title, @xlabel, @ylabel, @zlabel, ...
                @view, @axislimits, @axisstyle, @axisdirection, @axisvisibility);
            otp.utils.FancyPlot.setPlotProps(ax, config, 'xscale', 'yscale', 'zscale');            
        end
        
        function addLegendParams(p, numVars)
            p.addParameter('Legend', {}, @(x) iscell(x) || isa(x, 'function_handle'));
            p.addParameter('LegendIndices', 1:numVars);
            p.addParameter('MaxLegendLabels', 16);
        end
        
        function useLegendParams(ax, n, config)
            maxLabels = min(n, config.MaxLegendLabels);
            if iscell(config.Legend)
                actLabels = length(config.Legend);
                if actLabels == 0
                    legend(ax, 'off');
                    return;
                end
                labelIndices = round(linspace(1, actLabels, min(actLabels, maxLabels)));
                childIndices = config.LegendIndices(labelIndices);
                labels = config.Legend(labelIndices);
            else
                childIndices = config.LegendIndices(round(linspace(1, n, maxLabels)));
                labels = arrayfun(config.Legend, childIndices, 'UniformOutput', false);
            end
            
            reversedChildren = flipud(ax.Children);
            legend(ax, reversedChildren(childIndices), labels);
        end
    end
    
    methods (Access = private)
        function obj = FancyPlot()
        end
    end
end

