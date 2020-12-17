classdef (Abstract) Problem < handle
    
    properties (SetAccess = immutable)
        Name % A human-readable representation of the problem
    end
    
    properties (SetAccess = immutable, GetAccess = private)
        ExpectedNumVars
    end
    
    properties (SetAccess = protected)
        Rhs
    end
    
    properties (Access = private)
        Settings
    end
    
    properties (Dependent)
        TimeSpan % The time interval of the problem
        Y0 % The initial condition
        Parameters % Additional variables to pass to the F function
        NumVars % The dimension of the ODE
    end
    
    methods
        function obj = Problem(name, expectedNumVars, timeSpan, y0, parameters)
            % Constructs a problem
            
            % Switch to class parameter validation when better supported
            if ~ischar(name) || isempty(name)
                error('The problem name must be a nonempty character array');
            end
            obj.Name = name;
            obj.ExpectedNumVars = expectedNumVars;
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
        function varargout = plot(obj, sol, varargin)
            % Plots all trajectories y versus time
            [t, y, params] = obj.parseSolution(sol, varargin{:});
            fig = obj.internalPlot(t, y, params{:});
            
            if nargout > 0
                varargout{1} = fig;
            end
        end
        
        function varargout = plotPhaseSpace(obj, sol, varargin)
            % Plots a selection of trajectories with respect to each other
            [t, y, params] = obj.parseSolution(sol, varargin{:});
            fig = obj.internalPlotPhaseSpace(t, y, params{:});
            
            if nargout > 0
                varargout{1} = fig;
            end
        end
        
        function varargout = movie(obj, sol, varargin)
            % Plots an animation of the trajectories
            [t, y, params] = obj.parseSolution(sol, varargin{:});
            mov = obj.internalMovie(t, y, params{:});
            
            if nargout > 0
                varargout{1} = mov;
            end
        end
        
        function label = index2label(obj, index)
            % Gets a human-readable label for a particular component of the ODE
            if ~isscalar(index) || mod(index, 1) || index < 1 || index > obj.NumVars
                error('The index %d is not an integer between 1 and %d', index, obj.NumVars);
            end
            label = obj.internalIndex2label(index);
        end
        
        function sol = solve(obj, varargin)
            sol = obj.internalSolve(varargin{:});
        end
    end
    
    methods (Access = protected)
        function validateNewState(obj, newTimeSpan, newY0, newParameters)
            % Ensures the TimeSpan, Y0, and Parameters are valid
            if length(newTimeSpan) ~= 2
                error('TimeSpan must be a vector of two times');
            elseif ~isnumeric(newTimeSpan)
                error('TimeSpan must be numeric');
            elseif ~iscolumn(newY0)
                error('Y0 must be a column vector');
            elseif ~(isnumeric(newY0) && all(isfinite(newY0)))
                error('Y0 must be numeric and finite');
            elseif ~(isempty(obj.ExpectedNumVars) || length(newY0) == obj.ExpectedNumVars)
                error('Expected Y0 to have %d components but has %d', obj.ExpectedNumVars, length(newY0));
            elseif ~isstruct(newParameters)
                error('Parameters must be a struct');
            end
        end
        
        function fig = internalPlot(obj, t, y, varargin)
            % Plots all trajectories in y versus time assuming t and y are valid
            fig = figure;
            ax = axes(fig);
            otp.utils.FancyPlot.plot(ax, t, y.', ...
                'title', obj.Name, ...
                'xlabel', 't', ...
                'ylabel', 'y', ...
                'legend', @obj.internalIndex2label, ...
                varargin{:});
        end
        
        function fig = internalPlotPhaseSpace(obj, t, y, varargin)
            % Plots a selection of trajectories with respect to each other assuming t and y are valid
            
            p = inputParser;
            p.KeepUnmatched = true;
            p.addParameter('Vars', 1:min(otp.utils.PhysicalConstants.ThreeDimensional, obj.NumVars), @ismatrix);
            p.parse(varargin{:});
            vars = p.Results.Vars;
            
            fig = figure;
            ax = axes(fig);
            
            [numLines, dim] = size(vars);
            switch dim
                case otp.utils.PhysicalConstants.OneDimensional
                    f = zeros(length(vars), length(t));
                    for i = 1:length(t)
                        fFullCur = obj.Rhs.F(t(i), y(:, i));
                        f(:, i) = fFullCur(vars);
                    end
                    
                    otp.utils.FancyPlot.plot(ax, y(vars, :).', f.', ...
                        'title', 'Phase Line', ...
                        'xlabel', 'y', ...
                        'ylabel', 'f(y)', ...
                        'legend', @(i) obj.internalIndex2label(vars(i)), ...
                        p.Unmatched);
                case otp.utils.PhysicalConstants.TwoDimensional
                    if numLines == 1
                        xLabel = obj.internalIndex2label(vars(1));
                        yLabel = obj.internalIndex2label(vars(2));
                        leg = {};
                    else
                        xLabel = [];
                        yLabel = [];
                        leg = @(i) sprintf('%s vs %s', obj.internalIndex2label(vars(i, 1)), ...
                            obj.internalIndex2label(vars(i, 2)));
                    end
                    otp.utils.FancyPlot.plot(ax, y(vars(:, 1), :).', y(vars(:, 2), :).', ...
                        'title', 'Phase Plane', ...
                        'xlabel', xLabel, ...
                        'ylabel', yLabel, ...
                        'legend', leg, ...
                        p.Unmatched);
                case otp.utils.PhysicalConstants.ThreeDimensional
                    if numLines == 1
                        xLabel = obj.internalIndex2label(vars(1));
                        yLabel = obj.internalIndex2label(vars(2));
                        zLabel = obj.internalIndex2label(vars(3));
                        leg = {};
                    else
                        xLabel = [];
                        yLabel = [];
                        zLabel = [];
                        leg = @(i) sprintf('%s vs %s vs %s', obj.internalIndex2label(vars(i, 1)), ...
                            obj.internalIndex2label(vars(i, 2)), obj.internalIndex2label(vars(i, 3)));
                    end
                    otp.utils.FancyPlot.plot(ax, y(vars(:, 1), :).', y(vars(:, 2), :).', y(vars(:, 3), :).', ...
                        'title', 'Phase Space', ...
                        'xlabel', xLabel, ...
                        'ylabel', yLabel, ...
                        'zlabel', zLabel, ...
                        'legend', leg, ...
                        'view', [45, 45], ...
                        p.Unmatched);
                otherwise
                    error('Cannot plot a %dD phase space', dim);
            end
        end
        
        function mov = internalMovie(obj, t, y, varargin)
            mov = otp.utils.movie.LineMovie('title', obj.Name, varargin{:});
            mov.record(t, y);
        end
        
        function label = internalIndex2label(~, index)
            % Gets a human-readable label for a particular component of the ODE assuming index is a valid integer
            label = sprintf('y_{%d}', index);
        end
        
        function sol = internalSolve(obj, varargin)
            p = inputParser;
            p.KeepUnmatched = true;
            p.addParameter('Method', @ode15s, @(m) isa(m, 'function_handle'));
            p.parse(varargin{:});
            
            options = obj.Rhs.odeset(p.Unmatched);
            
            sol = p.Results.Method(obj.Rhs.F, obj.TimeSpan, obj.Y0, options);
            
            if ~isfield(sol, 'ie')
                return;
            end
            
            problem = obj;
            while sol.x(end) ~= problem.TimeSpan(end)
                [isterminal, problem] = problem.Rhs.OnEvent(sol, problem);
                
                if isterminal
                    return;
                end
                
                options = problem.Rhs.odeset(options);
                sol = odextend(sol, problem.Rhs.F, problem.TimeSpan(end), problem.Y0, options);
            end
        end
    end
    
    methods (Access = private)
        function [t, y, params] = parseSolution(obj, sol, varargin)
            if isstruct(sol)
                t = sol.x;
                y = sol.y;
                params = varargin;
            else
                t = sol;
                y = varargin{1};
                params = varargin(2:end);
            end
            
            if ~(isvector(t) && isnumeric(t))
                error('The times must be a vector of numbers');
            elseif ~(ismatrix(y) && isnumeric(y))
                error('The solution must be matrix of numbers');
            end
            
            steps = length(t);
            [m, n] = size(y);
            
            if m == steps && n == obj.NumVars && m ~= n
                y = y.';
            elseif m ~= obj.NumVars
                error('There are %d timesteps, but %d solution states', steps, m);
            elseif n ~= steps
                error('Expected solution to have %d variables but has %d', obj.NumVars, n);
            end
        end
    end
    
    methods (Abstract, Access = protected)
        % This method is called when either TimeSpan, Y0, or parameters are changed.  It should update F and other properties such as a Jacobian to reflect the changes.
        onSettingsChanged(obj);
    end
end
