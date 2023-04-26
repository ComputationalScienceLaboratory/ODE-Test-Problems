classdef (Abstract) Problem < handle
    
    properties (SetAccess = private)
        % A human-readable representation of the problem
        Name %MATLAB ONLY: (1,:) char
    end
    
    properties (SetAccess = protected)
        RHS %MATLAB ONLY: (1,1) otp.RHS = otp.RHS(@() [])
    end
    
    properties (Access = private)
        ExpectedNumVars %MATLAB ONLY: {mustBeScalarOrEmpty, mustBeInteger, mustBePositive}
        
        % Determines if the Problem properties are still being set. Once set, it
        % is ok to call onSettingsChanged.
        Initialized = false
        
        % The following internal properties represent the state of the problem
        % and have matching external properties. The external properties have to
        % be dependent because they trigger onSettingsChanged and access Problem
        % properties
        
        InternalTimeSpan
        InternalY0
        InternalParameters
    end
    
    properties (Dependent)
        % The time interval of the problem
        TimeSpan %MATLAB ONLY: (1,2) {otp.utils.validation.mustBeNumerical}
        
        % The initial condition
        Y0 %MATLAB ONLY: (:,1) {otp.utils.validation.mustBeNumerical}
        
        % Additional variables to pass to the F function
        Parameters %MATLAB ONLY: (1,1)
        
        % The dimension of the ODE
        NumVars
    end
    
    methods
        function obj = Problem(name, expectedNumVars, timeSpan, y0, parameters)
            % Constructs a problem
            obj.Name = name;
            obj.ExpectedNumVars = expectedNumVars;
            obj.TimeSpan = timeSpan;
            obj.Y0 = y0;
            obj.Initialized = true;
            obj.Parameters = parameters;
        end
        
        function set.TimeSpan(obj, value)
            obj.InternalTimeSpan = value;
            if obj.Initialized
                obj.onSettingsChanged();
            end
        end
        
        function timeSpan = get.TimeSpan(obj)
            timeSpan = obj.InternalTimeSpan;
        end
        
        function set.Y0(obj, value)
            numVars = length(value);
            if ~isempty(obj.ExpectedNumVars) && numVars ~= obj.ExpectedNumVars
                error('OTP:invalidY0', ...
                    'Expected Y0 to have %d components but has %d', ...
                    obj.ExpectedNumVars, numVars);
            end
            obj.InternalY0 = value;
            if obj.Initialized
                obj.onSettingsChanged();
            end
        end
        
        function y0 = get.Y0(obj)
            y0 = obj.InternalY0;
        end
        
        function set.Parameters(obj, value)
            obj.InternalParameters = value;
            obj.onSettingsChanged();
        end
        
        function parameters = get.Parameters(obj)
            parameters = obj.InternalParameters;
        end
        
        function vars = get.NumVars(obj)
            vars = length(obj.InternalY0);
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
                error('OTP:indexOutOfBounds', ...
                    'The index %d is not an integer between 1 and %d', ...
                    index, obj.NumVars);
            end
            label = obj.internalIndex2label(index);
        end
        
        function sol = solve(obj, varargin)
            sol = obj.internalSolve(varargin{:});
        end
        
        function y = solveExactly(obj, t)
            if nargin < 2
                t = obj.TimeSpan(2);
            else
                t = obj.parseTime(t);
            end
            y = obj.internalSolveExactly(t);
        end
    end
    
    methods (Access = protected)
        % This method is called when either TimeSpan, Y0, or parameters are changed. It should
        % update F and other properties such as a Jacobian to reflect the changes.
        function onSettingsChanged(obj)
            otp.utils.compatibility.abstract(obj);
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
                error('OTP:invalidPhaseDimension', ...
                    'Cannot plot a %dD phase space', dim);
            end
            
            fig = figure;
            ax = axes(fig);
            
            if numLines == 1
                labels = arrayfun(@obj.internalIndex2label, vars, 'UniformOutput', false);
                leg = {};
            else
                labels = cell(dim, 1);
                % OCTAVE FIX: function handle from class not accessible in anonymous function
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
            p.addParameter('Solver', otp.utils.Solver.Stiff);
            p.parse(varargin{:});
            
            % odeset is case sensitive for structs so convert unmatched parameters to a cell array
            unmatched = namedargs2cell(p.Unmatched);
            options = obj.RHS.odeset(unmatched{:});
            
            sol = feval(p.Results.Solver, obj.RHS.F, obj.TimeSpan, obj.Y0, options);
            
            problem = obj;
            while isfield(sol, 'ie') && sol.x(end) ~= problem.TimeSpan(end)
                % OCTAVE BUG: sol.xe and sol.ye are transposed compared to MATLAB
                [isterminal, problem] = problem.RHS.OnEvent(sol, problem);
                
                if isterminal
                    return;
                end
                
                options = problem.RHS.odeset(unmatched{:});
                % OCTAVE FIX: odextend not supported
                if exist('odextend', 'file')
                    sol = odextend(sol, problem.RHS.F, problem.TimeSpan(end), problem.Y0, options);
                else
                    sol = otp.utils.compatibility.odextend(sol, problem.RHS.F, problem.TimeSpan(end), ...
                        problem.Y0, options);
                end
            end
        end
        
        function y = internalSolveExactly(~, ~)
            y = 'This problem does not provide an exact solution';
            error('OTP:noExactSolution', y);
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
            
            t = obj.parseTime(t);
            if ~(ismatrix(y) && otp.utils.validation.isNumerical(y))
                error('OTP:invalidSolution', ...
                    'The solution must be matrix of numbers');
            end
            
            steps = length(t);
            [m, n] = size(y);
            
            if m == steps && n == obj.NumVars && m ~= n
                y = y.';
            elseif m ~= obj.NumVars
                error('OTP:invalidSolution', ...
                    'There are %d timesteps, but %d solution states', steps, m);
            elseif n ~= steps
                error('OTP:invalidSolution', ...
                    'Expected solution to have %d variables but has %d', ...
                    obj.NumVars, n);
            end
        end
        
        function t = parseTime(~, t)
            if ~isvector(t) || isempty(t) || ~otp.utils.validation.isNumerical(t)
                error('OTP:invalidSolution', ...
                    'The times must be a nonempty vector of numbers');
            end
            % Convert to row vector for consistency
            t = t(:).';
        end
    end
end
