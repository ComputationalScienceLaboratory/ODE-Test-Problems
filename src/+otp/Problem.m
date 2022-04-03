classdef (Abstract) Problem < handle
    
    properties (SetAccess = private)
        Name % A human-readable representation of the problem
    end
    
    properties (SetAccess = protected)
        RHS
    end
    
    properties (Access = private)
        Settings
        ExpectedNumVars
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
            
            if ~ischar(name)
                error('The problem name must be a nonempty character array');
            end
            obj.Name = name;
            obj.ExpectedNumVars = expectedNumVars;
            
            % IDEA: Make Settings a class with property validation
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
        % This method is called when either TimeSpan, Y0, or parameters are changed.  It should update F and other properties such as a Jacobian to reflect the changes.  This is effevtively an abstract function but not explicitly marked so in order to support Octave
        function onSettingsChanged(obj)
            otp.utils.compatibility.abstract(obj);
        end
        
        function validateNewState(obj, newTimeSpan, newY0, newParameters)
            % Ensures the TimeSpan, Y0, and Parameters are valid
            if length(newTimeSpan) ~= 2
                error('TimeSpan must be a vector of two times');
            elseif ~otp.utils.validation.isNumerical(newTimeSpan)
                error('TimeSpan must be numeric');
            elseif ~iscolumn(newY0)
                error('Y0 must be a column vector');
            elseif ~otp.utils.validation.isNumerical(newY0)
                error('Y0 must be numeric');
            elseif ~(isempty(obj.ExpectedNumVars) || length(newY0) == obj.ExpectedNumVars)
                error('Expected Y0 to have %d components but has %d', obj.ExpectedNumVars, length(newY0));
            elseif isempty(newParameters)
                error('Parameters cannot be empty');
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
        
        function fig = internalPlotPhaseSpace(obj, ~, y, varargin)
            % Plots a selection of trajectories with respect to each other assuming t and y are valid
            
            p = inputParser;
            p.KeepUnmatched = true;
            p.addParameter('Vars', 1:min(otp.utils.PhysicalConstants.ThreeD, obj.NumVars), @ismatrix);
            p.parse(varargin{:});
            vars = p.Results.Vars;
            
            [numLines, dim] = size(vars);
            if dim < otp.utils.PhysicalConstants.TwoD || dim > otp.utils.PhysicalConstants.ThreeD
                error('Cannot plot a %dD phase space', dim);
            end
            
            fig = figure;
            ax = axes(fig);
            
            if numLines == 1
                labels = arrayfun(@obj.internalIndex2label, vars, 'UniformOutput', false);
                leg = {};
            else
                labels = cell(dim, 1);
                % Octave bug: function handle from class not working with
                % arrayfun so stored in local var first
                labelFun = @obj.internalIndex2label;
                leg = @(i) strjoin(arrayfun(labelFun, vars(i, :), 'UniformOutput', false), ' vs ');
            end
            
            if dim == otp.utils.PhysicalConstants.TwoD
                otp.utils.FancyPlot.plot(ax, y(vars(:, 1), :).', y(vars(:, 2), :).', ...
                    'title', sprintf('%s Phase Plane', obj.Name), ...
                    'xlabel', labels{otp.utils.PhysicalConstants.OneD}, ...
                    'ylabel', labels{otp.utils.PhysicalConstants.TwoD}, ...
                    'legend', leg, ...
                    p.Unmatched);
            else
                otp.utils.FancyPlot.plot(ax, y(vars(:, 1), :).', y(vars(:, 2), :).', y(vars(:, 3), :).', ...
                    'title', sprintf('%s Phase Space', obj.Name), ...
                    'xlabel', labels{otp.utils.PhysicalConstants.OneD}, ...
                    'ylabel', labels{otp.utils.PhysicalConstants.TwoD}, ...
                    'zlabel', labels{otp.utils.PhysicalConstants.ThreeD}, ...
                    'legend', leg, ...
                    'view', otp.utils.PhysicalConstants.ThreeD, ...
                    p.Unmatched);
            end
        end
        
        function mov = internalMovie(obj, t, y, varargin)
            mov = otp.utils.movie.TrajectoryMovie('title', obj.Name, varargin{:});
            mov.record(t, y);
        end
        
        function label = internalIndex2label(~, index)
            % Gets a human-readable label for a particular component of the ODE assuming index is a valid integer
            label = sprintf('y_{%d}', index);
        end
        
        function sol = internalSolve(obj, varargin)
            p = inputParser;
            p.KeepUnmatched = true;
            % Filter name-value pairs not passed to odeset
            p.addParameter('Solver', otp.utils.Solver.Stiff, @(m) isa(m, 'function_handle'));
            p.parse(varargin{:});
            
            % odeset is case sensitive for structs so convert unmatched parameters to a cell array
            unmatched = namedargs2cell(p.Unmatched);
            options = obj.RHS.odeset(unmatched{:});
            
            sol = p.Results.Solver(obj.RHS.F, obj.TimeSpan, obj.Y0, options);
            
            if ~isfield(sol, 'ie')
                % All done if no event occurred
                return;
            end
            
            problem = obj;
            while sol.x(end) ~= problem.TimeSpan(end)
                [isterminal, problem] = problem.RHS.OnEvent(sol, problem);
                
                if isterminal
                    return;
                end
                
                % TODO: Octave does not support odextend
                options = problem.RHS.odeset(unmatched{:});
                sol = odextend(sol, problem.RHS.F, problem.TimeSpan(end), ...
                    problem.Y0, options);
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
            
            if ~(isvector(t) && otp.utils.validation.isNumerical(t))
                error('The times must be a vector of numbers');
            elseif ~(ismatrix(y) && otp.utils.validation.isNumerical(y))
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
end
