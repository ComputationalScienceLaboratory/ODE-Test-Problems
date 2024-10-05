classdef (Abstract) Problem < handle
    % The superclass for all problems in OTP.
    %
    % A problem is defined by a differential equation
    %
    % $$M(t, y(t); p) y'(t) = f(t, y(t); p)$$
    %
    % a time span $t ∈ [t_0, t_f]$, initial conditions $y(t_0) = y_0$, and any parameters $p$. The unknown solution
    % function is $y(t) ∈ ℂ^N$.
    %
    % This class provides the basic infrastructure for defining, solving, plotting, and animating a problem.
    % 
    % See Also
    % --------
    % otp.RHS
    % otp.Parameters
    %
    % ode : https://www.mathworks.com/help/matlab/ref/ode.html
    
    properties (SetAccess = private)
        % A human-readable representation of the problem.
        Name %MATLAB ONLY: (1,:) char
    end
    
    properties (SetAccess = protected)
        % The right-hand side and related properties of the differential equation.
        % 
        % This property is an :class:`otp.RHS` which is regenerated when the problem's time span, initial conditions, or
        % parameters change.
        %
        % Example
        % -------
        % >>> problem = otp.linear.presets.Canonical;
        % >>> problem.RHS.F
        % ans =
        % <BLANKLINE>
        % @(~, y) lambda * y
        %
        % See Also
        % --------
        % otp.RHS
        RHS %MATLAB ONLY: (1,1) otp.RHS = otp.RHS(@() [])
    end
    
    properties (Access = private)
        % The expected number of variables or an empty array for an arbitrary number.
        ExpectedNumVars %MATLAB ONLY: {mustBeScalarOrEmpty, mustBeInteger, mustBePositive}
        
        % Determines if the problem properties are still being set. Once set, it is ok to call onSettingsChanged.
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
        % A mutable time interval $[t_0, t_f]$ over which the problem is defined.
        %
        % Example
        % -------
        % >>> problem = otp.protherorobinson.presets.Canonical;
        % >>> problem.TimeSpan
        % ans =
        % <BLANKLINE>
        %     0   15
        % >>> problem.TimeSpan(2) = 100;
        TimeSpan %MATLAB ONLY: (1,2) {otp.utils.validation.mustBeNumerical}
        
        % A mutable column vector for the initial conditions $y(t_0) = y_0$.
        %
        % Example
        % -------
        % >>> problem = otp.lotkavolterra.presets.Canonical;
        % >>> problem.Y0
        % ans =
        % <BLANKLINE>
        %     1
        %     2
        % >>> problem.Y0 = [3; 4];
        Y0 %MATLAB ONLY: (:,1) {otp.utils.validation.mustBeNumerical}
        
        % A mutable :class:`otp.Parameters` representing the problem parameters $p$.
        %
        % Example
        % -------
        % >>> problem = otp.nbody.presets.Canonical;
        % >>> problem.Parameters.GravitationalConstant
        % ans = 1
        % >>> problem.Parameters.Masses(1) = 2;
        %
        % See Also
        % --------
        % otp.Parameters
        Parameters %MATLAB ONLY: (1,1) otp.Parameters
        
        % The number of variables $N$ of the problem.
        %
        % Example
        % -------
        % >>> problem = otp.cusp.presets.Canonical;
        % >>> problem.NumVars
        % ans = 96
        % >>> problem.Y0 = ones(30, 1);
        % >>> problem.NumVars
        % ans = 30
        NumVars
    end
    
    methods
        function obj = Problem(name, expectedNumVars, timeSpan, y0, parameters)
            % Create a problem object.
            %
            % Parameters
            % ----------
            % name : char(1, :)
            %    A human-readable representation of the problem.
            % expectedNumVars : numeric or []
            %    The expected number of variables or an empty array for an arbitrary number.
            % timeSpan : numeric(1, 2)
            %    The start and final time.
            % y0 : numeric(:, 1)
            %    The initial conditions.
            % parameters : otp.Parameters
            %    The parameters.
            
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
                error('OTP:invalidY0', 'Expected Y0 to have %d components but has %d', obj.ExpectedNumVars, numVars);
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
            % Plot all solution trajectories with time on the x-axis and $y(t)$ on the y-axis.
            %
            % Each call to this function creates a new figure and displays all solution variables. It accepts as input
            % the two standard output formats of MATLAB's differential equation solvers: a solution structure or a
            % ``[t, y]`` pair.
            %
            % Warning
            % -------
            % A plot can appear jagged if the solution time points are too coarse. In MATLAB,
            % `deval <https://www.mathworks.com/help/matlab/ref/deval.html>`_ can be used to evaluate the solution at a
            % user-specified set of points.
            %
            % Parameters
            % ----------
            % sol : struct or numeric(1, :) or numeric(:, 1)
            %    A solution structure with properties ``x`` and ``y``. The length of one dimension of the matrix ``y``
            %    must match the length (number of time points) of the vector ``x``. If ``y`` is square, each column
            %    should be a state and each row the trajectory of a single variable. Alternatively, this argument can be
            %    a vector of time points.
            % y : numeric(:, :), optional
            %    If the first argument is a vector of time points, this should be the corresponding matrix of solutions.
            %    The length of one dimension must match the length (number of time points) of ``x``. If square, each row
            %    should be a state and each column the trajectory of a single variable.
            % varargin
            %    A variable number of name-value pairs. Accepted names include
            %
            %    - ``Title`` – A string for the figure title.
            %    - ``XLabel`` – A string for the x-axis label.
            %    - ``YLabel`` – A string for the y-axis label.
            %    - ``ZLabel`` – A string for the z-axis label.
            %    - ``View`` – An array specifying the camera line of sight following
            %      `MATLAB's specification <https://www.mathworks.com/help/matlab/ref/view.html>`__.
            %    - ``ColorOrder`` – The color order palette following
            %      `MATLAB's specification <https://www.mathworks.com/help/matlab/ref/colororder.html>`__.
            %    - ``Axis`` – The axis limits and aspect ratios following
            %      `MATLAB's specification <https://www.mathworks.com/help/matlab/ref/axis.html>`__.
            %    - ``LineStyleOrder`` – The line style order following
            %      `MATLAB's specification <https://www.mathworks.com/help/matlab/ref/linestyleorder.html>`__.
            %    - ``XScale`` – Either ``'linear'`` or ``'log'``.
            %    - ``YScale`` – Either ``'linear'`` or ``'log'``.
            %    - ``ZScale`` – Either ``'linear'`` or ``'log'``.
            %    - ``FontName`` – A string for the font name.
            %    - ``FontSize`` – A size in the unit of points for the font.
            %    - ``Legend`` –  A cell array of strings or a function handle with the signature ``label = fun(index)``
            %      specifying the label of lines to show in the legend.
            %    - ``MaxLegendLabels`` – The maximum number of entries to show in the legend. If the number of lines
            %      exceeds this, only an evenly-spaced subset appears in the legend.
            %
            % Returns
            % -------
            % fig : figure, optional
            %    The figure created for the plot.
            %
            % Examples
            % --------
            % >>> problem = otp.trigonometricdae.presets.Canonical;
            % >>> sol = problem.solve();
            % >>> problem.plot(sol, 'Axis', 'square', 'XLabel', 'Time');
            % >>> x = linspace(p.TimeSpan(1), p.TimeSpan(2), 500);
            % >>> fig = problem.plot(x, deval(x, sol), 'Title', 'Another Plot');
            %
            % >>> problem = otp.vanderpol.presets.Canonical;
            % >>> [t, y] = ode15s(problem.RHS.F, problem.TimeSpan, problem.Y0);
            % >>> problem.plot(t, y);

            [t, y, params] = obj.parseSolution(sol, varargin{:});
            fig = obj.internalPlot(t, y, params{:});
            
            if nargout > 0
                varargout{1} = fig;
            end
        end
        
        function varargout = plotPhaseSpace(obj, sol, varargin)
            % Plot a selection of solution trajectories with respect to each other.
            %
            % A phase plot is 2D or 3D with one or more lines. For each line, the x-, y-, and z-axis can represent a
            % different user-specified component of the solution. Each call to this function creates a new figure. It
            % accepts as input the two standard output formats of MATLAB's differential equation solvers: a solution
            % structure or a ``[t, y]`` pair.
            %
            % Warning
            % -------
            % A plot can appear jagged if the solution time points are too coarse. In MATLAB, `deval`_ can be used to
            % evaluate the solution at a user-specified set of points.
            %
            % Parameters
            % ----------
            % sol : struct or numeric(1, :) or numeric(:, 1)
            %    A solution structure with properties ``x`` and ``y``. The length of one dimension of the matrix ``y``
            %    must match the length (number of time points) of the vector ``x``. If ``y`` is square, each column
            %    should be a state and each row the trajectory of a single variable. Alternatively, this argument can be
            %    a vector of time points.
            % y : numeric(:, :), optional
            %    If the first argument is a vector of time points, this should be the corresponding matrix of solutions.
            %    The length of one dimension must match the length (number of time points) of ``x``. If square, each row
            %    should be a state and each column the trajectory of a single variable.
            % varargin
            %    A variable number of name-value pairs. Accepted names include those supported by
            %    :func:`otp.Problem.plot` as well as the following:
            %
            %    - ``Vars`` – a matrix of variable indices where each row corresponds to a line in the plot and columns
            %      one, two, and optionally three correspond to the x-, y-, and z-axis, respectively.
            %
            % Returns
            % -------
            % fig : figure, optional
            %    The figure created for the plot.
            %
            % Examples
            % --------
            % >>> problem = otp.lorenz63.presets.Canonical;
            % >>> sol = problem.solve();
            % >>> problem.plotPhaseSpace(sol, 'Title', 'Lorenz Butterfly');
            % >>> problem.plotPhaseSpace(sol, 'Vars', [1, 2; 2, 3; 3, 1]);

            [t, y, params] = obj.parseSolution(sol, varargin{:});
            fig = obj.internalPlotPhaseSpace(t, y, params{:});
            
            if nargout > 0
                varargout{1} = fig;
            end
        end
        
        function varargout = movie(obj, sol, varargin)
            % Create an animation of solution trajectories.
            %
            % Each call to this function creates a new figure. It accepts as input the two standard output formats of
            % MATLAB's differential equation solvers: a solution structure or a ``[t, y]`` pair.
            %
            % Warning
            % -------
            % Octave has limited movie functionality and support. For most problems, the movie will not work. Saving a
            % movie to a file is currently unsupported.
            %
            % Warning
            % -------
            % A movie can appear jerky if the solution time points are too coarse. In MATLAB, `deval`_ can be used to
            % evaluate the solution at a user-specified set of points.
            %
            % Parameters
            % ----------
            % sol : struct or numeric(1, :) or numeric(:, 1)
            %    A solution structure with properties ``x`` and ``y``. The length of one dimension of the matrix ``y``
            %    must match the length (number of time points) of the vector ``x``. If ``y`` is square, each column
            %    should be a state and each row the trajectory of a single variable. Alternatively, this argument can be
            %    a vector of time points.
            % y : numeric(:, :), optional
            %    If the first argument is a vector of time points, this should be the corresponding matrix of solutions.
            %    The length of one dimension must match the length (number of time points) of ``x``. If square, each row
            %    should be a state and each column the trajectory of a single variable.
            % varargin
            %    A variable number of name-value pairs. Accepted names include those supported by
            %    :func:`otp.Problem.plot` as well as the following:
            %
            %    - ``Save`` – If ``false`` (default) the movie will play but the frames will not be save for playback.
            %      If ``true`` the frames will be saved in memory for playback. If a string or a
            %      `VideoWriter <https://www.mathworks.com/help/matlab/ref/videowriter.html>`__, the movie will be
            %      written to a file.
            %    - ``FrameRate`` – The number of frames per second when playing the movie.
            %    - ``Duration`` – The length in seconds of the movie. Frames may need to be skipped or duplicated to
            %      accommodate.
            %    - ``Size`` – An array ``[width, height]`` for the figure size in pixels.
            %    - ``Smooth`` – If ``true`` (default), solution states are uniformly sampled for frames based on the
            %      corresponding solution times. If ``false`` solution states are sampled uniformly by time step index
            %      which may lead to the inconsistent playback speeds.
            %
            % Returns
            % -------
            % mov : otp.utils.movie.Movie, optional
            %    A movie object which can be replayed using the ``play()`` method if saved.
            %
            % Examples
            % --------
            % >>> problem = otp.pendulum.presets.Canonical('NumBobs', 8);
            % >>> sol = problem.solve();
            % >>> mov = problem.movie(sol, 'Save', true, 'Duration', 5);
            % >>> mov.play();
            %
            % >>> problem = otp.bouncingball.presets.RandomTerrain;
            % >>> sol = problem.solve();
            % >>> mov = problem.movie(sol, 'Save', 'movie.avi', 'FrameRate', 30);

            [t, y, params] = obj.parseSolution(sol, varargin{:});
            mov = obj.internalMovie(t, y, params{:});
            
            if nargout > 0
                varargout{1} = mov;
            end
        end
        
        function label = index2label(obj, index)
            % Get a human-readable label for a particular component of the differential equation
            %
            % Parameters
            % ----------
            % index
            %    An index $i$ between $1$ and $N$ for component $y_i(t)$.
            %
            % Returns
            % -------
            % label : char(1, :)
            %    The name of the component.
            %
            % Example
            % -------
            % >>> problem = otp.brusselator.presets.Canonical;
            % >>> problem.index2label(2)
            % ans = Reactant Y

            if ~isscalar(index) || mod(index, 1) || index < 1 || index > obj.NumVars
                error('OTP:indexOutOfBounds', 'The index is not an integer between 1 and %d', obj.NumVars);
            end
            label = obj.internalIndex2label(index);
        end
        
        function sol = solve(obj, varargin)
            % Numerically compute a solution to the differential equation.
            %
            % This function will numerically integrate the differential equation until a terminal event is triggered,
            % the end of the time span is reached, or the solver throws an error. It is handy for generating a reference
            % solution or studying convergence of an integrator with respect to the tolerance.
            %
            % Note
            % ----
            % Different problem subclasses use different default solvers. The solver used is stored in the ``solver``
            % property of the returned solution structure.
            %
            % Warning
            % -------
            % ``ode15s`` in Octave transposes the ``y`` property of the returned solution structure. All Octave solvers
            % transpose event data compared to MATLAB.
            %
            % Parameters
            % ----------
            % varargin
            %    A variable number of name-value pairs. Accepted names include those supported by
            %    :func:`otp.RHS.odeset` as well as the following:
            %
            %    - ``Solver`` – A function handle to a differential equation solver which can be evaluated as
            %      ``sol = Solver(odefun, tspan, y0, options)``.
            %
            % Returns
            % -------
            % sol : struct
            %    A solution structure in the standard MATLAB solver output format. The time and solution steps are
            %    stored in the ``x`` and ``y`` properties, respectively.
            %
            % Example
            % -------
            % >>> problem = otp.pendulum.presets.Canonical;
            % >>> sol1 = problem.solve();
            % >>> sol2 = problem.solve('RelTol', 1e-8, 'Solver', @ode23);

            % No validation is needed, so directly call the protected internal solve function
            sol = obj.internalSolve(varargin{:});
        end
        
        function y = solveExactly(obj, t)
            % Compute the exact solution to the differential equation if available or throw an error otherwise.
            %
            % Parameters
            % ----------
            % t : numeric or numeric(1, :) or numeric(:, 1), optional
            %    The times at which to generate the exact solution. If not provided, the end of the time span $t_f$ is
            %    used.
            %
            % Returns
            % -------
            % y : numeric(:, :)
            %    A matrix in which element $(i, j)$ is $y_i(t_j)$.
            %
            % Examples
            % --------
            % >>> problem = otp.ascherlineardae.presets.Canonical;
            % >>> problem.solveExactly()
            % ans =
            % <BLANKLINE>
            %     1.5772
            %     1.2094
            %
            % >>> problem = otp.protherorobinson.presets.Canonical;
            % >>> sol = problem.solve();
            % >>> err = sol.y - problem.solveExactly(sol.x);
            % >>> problem.plot(sol.x, err, 'YLabel', 'Error');

            if nargin < 2
                t = obj.TimeSpan(2);
            else
                t = obj.parseTime(t);
            end
            y = obj.internalSolveExactly(t);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            % This method is called when either TimeSpan, Y0, or parameters are changed. It should update all RHS` to
            % reflect the change.

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
            % Plots a selection of trajectories with respect to each other assuming t and y are valid.
            
            p = inputParser;
            p.KeepUnmatched = true;
            p.addParameter('Vars', 1:min(otp.utils.PhysicalConstants.ThreeD, obj.NumVars), @ismatrix);
            p.parse(varargin{:});
            vars = p.Results.Vars;
            
            [numLines, dim] = size(vars);
            if dim < otp.utils.PhysicalConstants.TwoD || dim > otp.utils.PhysicalConstants.ThreeD
                error('OTP:invalidPhaseDimension', 'Cannot plot a %dD phase space', dim);
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
            % Creates an animation assuming t and y are valid.

            mov = otp.utils.movie.TrajectoryMovie('Title', obj.Name, varargin{:});
            mov.record(t, y);
        end
        
        function label = internalIndex2label(~, index)
            % Gets a human-readable label for a particular component of the ODE assuming index is a valid integer

            label = sprintf('y_{%d}', index);
        end
        
        function sol = internalSolve(obj, varargin)
            % Numerically compute a solution to the differential equation.

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
            % Throws an error that an exact solution is unavailable. Subclass can override this to provide an exact
            % solution when available.

            y = 'This problem does not provide an exact solution';
            error('OTP:noExactSolution', y);
        end
    end
    
    methods (Access = private)
        function [t, y, params] = parseSolution(obj, sol, varargin)
            % Puts the two types of ODE solver output (solution structure or [t, y]) into a consistent format

            if isstruct(sol)
                t = sol.x;
                y = sol.y.';
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
                error('OTP:invalidSolution', 'There are %d time steps, but %d solution states', steps, m);
            elseif n ~= steps
                error('OTP:invalidSolution', 'Expected solution to have %d variables but has %d', obj.NumVars, n);
            end
        end
        
        function t = parseTime(~, t)
            % Puts a vector of time points into a consistent row vector form

            if ~isvector(t) || isempty(t) || ~otp.utils.validation.isNumerical(t)
                error('OTP:invalidSolution', 'The times must be a nonempty vector of numbers');
            end
            
            t = t(:).';
        end
    end
end
