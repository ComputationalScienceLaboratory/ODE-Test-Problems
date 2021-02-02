classdef (Sealed) FancyPlot
    
    properties (Access = private, Constant)
        SupportedAxesFunctions = {@title, @xlabel, @ylabel, @zlabel, @view, @grid, @colororder, @axis};
        SupportedAxesProperties = {'linestyleorder', 'xscale', 'yscale', 'zscale', 'fontname', 'fontsize'};
    end
    
    methods (Static)
        function h = plot(ax, x, y, varargin)
            p = inputParser;
            p.addOptional('z', []);
            p.addParameter('plotter', []);
            otp.utils.FancyPlot.addAxesParameters(p);
            p.parse(varargin{:});
            config = p.Results;
            
            hold(ax, 'all');
            otp.utils.FancyPlot.configureAxes(ax, config);
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
            otp.utils.FancyPlot.configureLegend(ax, h, config);
            hold(ax, 'off');
        end
        
        function c = lighten(c, beta)
            if nargin < 2
                beta = 0.5;
            else
                beta = max(-1, min(1, beta));
            end
            
            if beta >= 0
                c = beta + (1 - beta) * c;
            else
                c = (1 + beta) * c;
            end
        end
        
        function limits = axisLimits(ax, dir, data, padding)
            if nargin < 4
                padding = 0.05;
            end
            
            if strcmp(get(ax, strcat(dir, 'scale')), 'linear')
                [yMin, yMax] = bounds(data, 'all');
                p = padding * (yMax - yMin);
                limits = [yMin - p, yMax + p];
            else
                [yMin, yMax] = bounds(data(data > 0));
                p = (yMax / yMin)^padding;
                limits = [yMin / p, yMax * p];
            end
            
            set(ax, strcat(dir, 'lim'), limits);
        end
    end
    
    methods (Static, Hidden)
        function addAxesParameters(p)
            for i = 1:length(otp.utils.FancyPlot.SupportedAxesFunctions)
                p.addParameter(func2str(otp.utils.FancyPlot.SupportedAxesFunctions{i}), []);
            end
            for i = 1:length(otp.utils.FancyPlot.SupportedAxesProperties)
                p.addParameter(otp.utils.FancyPlot.SupportedAxesProperties{i}, []);
            end
            
            p.addParameter('Legend', {}, @(x) iscell(x) || isa(x, 'function_handle'));
            p.addParameter('LegendIndices', []);
            p.addParameter('MaxLegendLabels', 10);
        end
        
        function configureAxes(ax, config)
            for i = 1:length(otp.utils.FancyPlot.SupportedAxesFunctions)
                prop = otp.utils.FancyPlot.SupportedAxesFunctions{i};
                val = config.(func2str(prop));
                if ~isempty(val)
                    prop(ax, val);
                end
            end
            
            for i = 1:length(otp.utils.FancyPlot.SupportedAxesProperties)
                prop = otp.utils.FancyPlot.SupportedAxesProperties{i};
                val = config.(prop);
                if ~isempty(val)
                    set(ax, prop, val);
                end
            end
        end
        
        function configureLegend(ax, targets, config)
            n = length(targets);
            maxLabels = min(n, config.MaxLegendLabels);
            legendIndices = config.LegendIndices;
            if isempty(legendIndices)
                legendIndices = 1:n;
            end
            
            if iscell(config.Legend)
                actLabels = length(config.Legend);
                if actLabels == 0
                    legend(ax, 'off');
                    return;
                end
                labelIndices = round(linspace(1, actLabels, min(actLabels, maxLabels)));
                childIndices = legendIndices(labelIndices);
                labels = config.Legend(labelIndices);
            else
                childIndices = legendIndices(round(linspace(1, n, maxLabels)));
                labels = arrayfun(config.Legend, childIndices, 'UniformOutput', false);
            end
            
            legend(ax, targets(childIndices), labels);
        end
    end
    
    methods (Access = private)
        function obj = FancyPlot()
        end
    end
end
