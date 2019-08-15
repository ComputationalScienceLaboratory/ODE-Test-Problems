classdef (Abstract) Problem < handle
    
    properties (SetAccess = immutable)
        Name % A human-readable representation of the problem
    end
    
    properties (SetAccess = protected)
        Rhs
    end
    
    properties (Access = private)
        Settings % A struct that groups the TimeSpan, Y0, and Parameter properties
    end
    
    properties (Dependent)
        TimeSpan % The time interval of the problem
        Y0 % The initial condition
        Parameters % Additional variables to pass to the F function
        NumVars % The dimension of the ODE
    end
    
    methods
        function obj = Problem(name, timeSpan, y0, parameters)
            % Constructs a problem
            
            % Switch to class parameter validation when better supported
            if ~ischar(name) || isempty(name)
                error('The problem name must be a nonempty character array');
            end
            obj.Name = name;
            
            obj.Settings = struct('timeSpan', timeSpan(:), 'y0', y0, 'parameters', parameters);
        end
        
        function set.TimeSpan(obj, value)
            obj.Settings.timeSpan = value(:);
        end
        
        function timeSpan = get.TimeSpan(obj)
            timeSpan = obj.Settings.timeSpan;
        end
        
        function set.Y0(obj, value)
            obj.Settings.y0 = value;
        end
        
        function y0 = get.Y0(obj)
            y0 = obj.Settings.y0;
        end
        
        function set.Parameters(obj, value)
            obj.Settings.parameters = value;
        end
        
        function parameters = get.Parameters(obj)
            parameters = obj.Settings.parameters;
        end
        
        function set.Settings(obj, value)
            obj.validateNewState(value.timeSpan, value.y0, value.parameters);
            obj.Settings = value;
            obj.onSettingsChanged();
        end
        
        function dimension = get.NumVars(obj)
            dimension = length(obj.Settings.y0);
        end
    end
    
    methods (Sealed)
        function fig = plot(obj, sol, varargin)
            % Plots all trajectories y versus time
            [t, y, args] = obj.parseSolution(sol, varargin{:});
            fig = obj.internalPlot(t, y, args{:});
        end
        
        function fig = plotState(obj, t, y, varargin)
            % Plots the state at a single time
            if ~(isscalar(t) && isnumeric(t))
                error('The time must be a number');
            end
            if ~(isvector(y) && isnumeric(y))
                error('The solution must be a numeric vector');
            end
            if length(y) ~= obj.NumVars
                error('Expected solution to have %d variables but has %d', obj.NumVars, length(y));
            end
            fig = obj.internalPlotState(t, y, varargin{:});
        end
        
        function fig = plotPhaseSpace(obj, sol, varargin)
            % Plots a selection of trajectories with respect to each other
            [t, y, args] = obj.parseSolution(sol, varargin{:});
            fig = obj.internalPlotPhaseSpace(t, y, args{:});
        end
        
        function varargout = movie(obj, sol, varargin)
            % Plots an animation of the trajectories
            [t, y, args] = obj.parseSolution(sol, varargin{:});
            [varargout{1:nargout}] = otp.utils.movie.moviemaker(t, y, @obj.internalMovieInit, ...
                @obj.internalMovieFrame, args{:});
        end
        
        function label = index2label(obj, index)
            % Gets a human-readable label for a particular component of the ODE
            if floor(index) ~= index || index < 1 || index > obj.NumVars
                error('The index %d is not an integer between 1 and %d', index, obj.NumVars);
            end
            label = obj.internalIndex2label(index);
        end
    end
    
    methods (Access = protected)
        function validateNewState(~, newTimeSpan, newY0, newParameters)
            % Ensures the TimeSpan, Y0, and Parameters are valid
            if length(newTimeSpan) ~= 2
                error('TimeSpan must be a vector of two times');
            end
            if ~(isnumeric(newTimeSpan) && all(isfinite(newTimeSpan)))
                error('TimeSpan must be numeric and finite');
            end
            
            if ~iscolumn(newY0)
                error('Y0 must be a column vector');
            end
            if ~(isnumeric(newY0) && all(isfinite(newY0)))
                error('Y0 must be numeric and finite');
            end
            
            if ~isstruct(newParameters)
                error('Parameters must be a struct');
            end
        end
        
        function fig = internalPlot(obj, t, y, varargin)
            % Plots all trajectories in y versus time assuming t and y are valid
            fig = figure;
            ax = axes(fig);
            otp.utils.FancyPlot.plot(ax, t, y, ...
                'title', obj.Name, ...
                'xlabel', 't', ...
                'legend', @obj.internalIndex2label, ...
                varargin{:});
        end
        
        function fig = internalPlotState(obj, t, y, varargin)
            % Plots the state at a single time assuming t and y are valid
            fig = figure;
            ax = axes(fig);
            c = categorical(arrayfun(@obj.internalIndex2label, 1:obj.NumVars, ...
                'UniformOutput', false));
            otp.utils.FancyPlot.bar(ax, c, y, ...
                'title', sprintf('%s at t=%g', obj.Name, t), ...
                varargin{:});
        end
        
        function fig = internalPlotPhaseSpace(obj, t, y, varargin)
            % Plots a selection of trajectories with respect to each other assuming t and y are valid
            
            if isempty(varargin) || ischar(varargin{1})
                if (obj.NumVars > 3)
                    indices = 1:2;
                else
                    indices = 1:obj.NumVars;
                end
            else
                indices = varargin{1};
                
                if ~isvector(indices) || length(indices) > 3
                    error('The indices must be a vector with at most 3 components');
                end
                
                varargin = varargin(2:end);
            end
            
            fig = figure;
            ax = axes(fig);
            
            switch length(indices)
                case 1
                    f = zeros(size(t));
                    F = obj.Rhs.F;
                    for i = 1:length(t)
                        fFullCur = F(t(i), y(i, :));
                        f(i) = fFullCur(indices);
                    end
                    
                    label = obj.index2label(indices);
                    otp.utils.FancyPlot.plot(ax, y(:, indices), f, ...
                        'title', 'Phase Plane', ...
                        'xlabel', label, ...
                        'ylabel', sprintf('f(%s)', label), ...
                        varargin{:});
                case 2
                    otp.utils.FancyPlot.plot(ax, y(:, indices(1)), y(:, indices(2)), ...
                        'title', 'Phase Plane', ...
                        'xlabel', obj.index2label(indices(1)), ...
                        'ylabel', obj.index2label(indices(2)), ...
                        varargin{:});
                case 3
                    otp.utils.FancyPlot.plot(ax, y(:, indices(1)), y(:, indices(2)), y(:, indices(3)), ...
                        'title', 'Phase Plane', ...
                        'xlabel', obj.index2label(indices(1)), ...
                        'ylabel', obj.index2label(indices(2)), ...
                        'zlabel', obj.index2label(indices(3)), ...
                        'view', [45, 45], ...
                        varargin{:});
            end
        end
        
        function initData = internalMovieInit(obj, fig, state, ~)
            ax = axes(fig);
            [t0, tEnd] = bounds(state.t);
            tRange = tEnd - t0;
            [yMin, yMax] = bounds(state.y, 'all');
            yRange = yMax - yMin;
            axis(ax, [t0 - 0.1 * tRange, tEnd + 0.1 * tRange, yMin - 0.1 * yRange, yMax + 0.1 * yRange]);
            
            initData = gobjects(state.numVars, 1);
            for i = 1:state.numVars
                initData(i) = animatedline(ax, 'Color', otp.utils.FancyPlot.color(state.numVars, i));
            end
            
            xlabel(ax, 't');
            otp.utils.FancyPlot.legend(ax, 'Legend', @obj.internalIndex2label);
        end
        
        function internalMovieFrame(obj, fig, initData, state, ~)
            title(fig.CurrentAxes, sprintf('%s at t=%g', obj.Name, state.tCur));
            for i = 1:state.numVars
                initData(i).addpoints(state.t(state.stepRange), state.y(state.stepRange, i));
            end
        end
        
        function label = internalIndex2label(~, index)
            % Gets a human-readable label for a particular component of the ODE assuming index is a valid integer
            label = sprintf('y_{%d}', index);
        end
    end
    
    methods (Access = private)
        function [t, y, args] = parseSolution(obj, sol, varargin)
            if isstruct(sol)
                t = sol.x;
                y = sol.y.';
                args = varargin;
            else
                t = sol;
                y = varargin{1};
                args = varargin(2:end);
            end
            
            if ~(isvector(t) && isnumeric(t))
                error('The times must be a vector of numbers');
            end
            if ~(ismatrix(y) && isnumeric(y))
                error('The solution must be matrix of numbers');
            end
            
            steps = length(t);
            [m, n] = size(y);
            
            if steps ~= m
                error('There are %d timesteps, but %d solution states', steps, m);
            end
            if obj.NumVars ~= n
                error('Expected solution to have %d variables but has %d', obj.NumVars, n);
            end
        end
    end
    
    methods (Abstract, Access = protected)
        % This method is called when either TimeSpan, Y0, or parameters are changed.  It should update F and other properties such as a Jacobian to reflect the changes.
        onSettingsChanged(obj);
    end
end
