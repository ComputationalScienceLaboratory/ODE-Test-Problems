classdef AscherLinearDAEProblem < otp.Problem
    % A linear differential-algebraic problem with a time-dependant mass matrix.
    %
    % The Ascher linear DAE Problem :cite:p:`Asc89` is an index-1 differential-agebraic equation given by
    %
    % $$
    % \begin{bmatrix}
    % 1 & -t \\
    % 0 & 0
    % \end{bmatrix} \begin{bmatrix} y'(t) \\ z'(t) \end{bmatrix} = \begin{bmatrix}
    % -1 & 1+t \\
    % β & -1-β t
    % \end{bmatrix} \begin{bmatrix} y(t) \\ z(t) \end{bmatrix} + \begin{bmatrix}
    % 0 \\
    % \sin(t)
    % \end{bmatrix}.
    % $$
    %
    % When the initial condition $y(0) = 1 , z(0) = β$ is used, the problem has the following closed-form solution:
    %
    % $$
    % \begin{bmatrix} y(t)\\ z(t) \end{bmatrix} = \begin{bmatrix}
    % t \sin(t) + (1 + β t) e^{-t}\\
    % β e^{-t} + \sin(t)
    % \end{bmatrix}.
    % $$
    %
    % This DAE problem can be used to investigate the convergence of implcit time-stepping methods due to its stiffness
    % and time-dependant mass matrix.
    %
    % Notes
    % -----
    % +---------------------+-----------------------------------------+
    % | Type                | DAE                                     |
    % +---------------------+-----------------------------------------+
    % | Number of Variables | 2                                       |
    % +---------------------+-----------------------------------------+
    % | Stiff               | possibly, depending on $β$              |
    % +---------------------+-----------------------------------------+
    %
    % Example
    % -------
    % >>> problem = otp.ascherlineardae.presets.Canonical('Beta', 50);
    % >>> t = linspace(0, 1);
    % >>> sol = problem.solveExactly(t);
    % >>> problem.plot(t, sol);

    methods
        function obj = AscherLinearDAEProblem(timeSpan, y0, parameters)
            % Create an Ascher linear DAE problem object.
            %
            % Parameters
            % ----------
            % timeSpan : numeric(1, 2)
            %    The start and final time.
            % y0 : numeric(2, 1)
            %    The initial condition.
            % parameters : AscherLinearDAEParameters
            %    The parameters.
            obj@otp.Problem('Ascher Linear DAE', 2, timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            beta = obj.Parameters.Beta;
            
            obj.RHS = otp.RHS(@(t, y) otp.ascherlineardae.f(t, y, beta), ...
                'Jacobian', @(t, y) otp.ascherlineardae.jacobian(t, y, beta), ...
                'Mass', @(t) otp.ascherlineardae.mass(t, [], beta), ...
                'MStateDependence', 'none', ...
                'MassSingular', 'yes');
        end

        function label = internalIndex2label(~, index)
            if index == 1
                label = 'Differential';
            else
                label = 'Algebraic';
            end
        end

        function y = internalSolveExactly(obj, t)
            beta = obj.Parameters.Beta;
            if ~isequal(obj.Y0, [1; beta])
                error('OTP:noExactSolution', ...
                    'An exact solution is unavailable for this initial condition');
            end
            
            y = [t .* sin(t) + (1 + beta * t) .* exp(-t); ...
                beta * exp(-t) + sin(t)];
        end
        
        function sol = internalSolve(obj, varargin)
            sol = internalSolve@otp.Problem(obj, ...
                'Solver', otp.utils.Solver.StiffNonConstantMass, varargin{:});
        end
    end
end
