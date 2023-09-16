classdef AscherLinearDAEProblem < otp.Problem
    % A simple linear differential algebraic problem.
    %
    % The Ascher linear DAE Problem :cite:p:`Asc89` is an index-1 differential agebraic 
    % equation given by
    %
    % $$
    % \begin{bmatrix}
    % 1 & -t \\
    % 0 & 0
    % \end{bmatrix} \begin{bmatrix} y'(t) \\ z'(t) \end{bmatrix} = \left[ \begin{array}{cc}
    % -1 & 1+t \\
    % \beta & -1-\beta t
    % \end{array}\right] \begin{bmatrix} y(t) \\ z(t) \end{bmatrix} + \begin{bmatrix}
    % 0 \\
    % \sin t
    % \end{bmatrix}.
    % $$
    %
    %  The problem has the following closed-form solution when the initial condition $y(0) = 1 , z(0) = \beta$ is used:
    %
    % $$
    % \begin{bmatrix} y(t)\\ z(t) \end{bmatrix} = \begin{bmatrix}
    % t \sin(t) + (1 + \beta  t) e^{-t}\\
    % \beta  e^{-t} + \sin(t)
    % \end{bmatrix}.
    % $$
    % This DAE problem 
    % can be used to investigate
    % the convergence of implcit time-stepping methods due to its stiffness and time-dependant mass
    % matrix.
    %
    % Notes
    % -----
    % +---------------------+-----------------------------------------+
    % | Type                | DAE                                     |
    % +---------------------+-----------------------------------------+
    % | Number of Variables | 2                                       |
    % +---------------------+-----------------------------------------+
    % | Stiff               | possibly, depending on $\beta$          |
    % +---------------------+-----------------------------------------+
    %
    % Example
    % -------
    % >>> problem = otp.ascherlineardae.presets.Canonical('Beta', 50);
    % >>> t = linspace(0,1,100);
    % >>> sol = problem.solveExcatly(t);
    % >>> problem.plot(sol);

    properties (Access = private, Constant)
        NumComps = 2
        VarNames = 'yz'
    end

    methods
        function obj = AscherLinearDAEProblem(timeSpan, y0, parameters)
            % Create an Ascher linear DAE problem object.
            %
            % Parameters
            % ----------
            % timeSpan : numeric(1, 2)
            %    The start and final time.
            % y0 : numeric(2, 1)
            %    The initial conditions.
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
        
        function sol = internalSolveExactly(obj, t)
            sol = [];
            beta = obj.Parameters.Beta;
            if ~isequal(obj.Y0, [1; beta])
                error('OTP:noExactSolution', ...
                    'An exact solution is unavailable for this initial condition');
            end
            
            y = [t .* sin(t) + (1 + beta * t) .* exp(-t); ...
                beta * exp(-t) + sin(t)];
            sol.x = t;
            sol.y = y;
        end
        
        function sol = internalSolve(obj, varargin)
            sol = internalSolve@otp.Problem(obj, ...
                'Solver', otp.utils.Solver.StiffNonConstantMass, varargin{:});
        end
    end
end
