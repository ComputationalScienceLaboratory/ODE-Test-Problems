classdef AscherLinearDAEProblem < otp.Problem
    % A simple linear differential algebraic problem.
    %
    % The Ascher linear DAE Problem :cite:p:`Asc89` is an index-1 differential agebraic 
    % equation given by $M(t) y' = A(t) y + q(t) $ where
    %
    % $$
    % M=\left(\begin{array}{cc}
    % 1 & -t \\
    % 0 & 0
    % \end{array}\right), \quad A=\left(\begin{array}{cc}
    % -1 & 1+t \\
    % \beta & -1-\beta t
    % \end{array}\right), \quad {q}=\left(\begin{array}{c}
    % 0 \\
    % \sin t
    % \end{array}\right), 
    % $$
    %
    % defined on timespan $t \in [0,1]$, and initial condition $y_0 = [1, \beta]^T$. The exact solution
    % is given by 
    %
    % $$
    % y = \begin{pmatrix}
    % t \sin(t) + (1 + \beta  t) e^{-t}\\
    % \beta  e^{-t} + \sin(t)
    % \end{pmatrix}.
    % $$
    %
    % Due to its stiffness and time-dependant mass
    % matrix, this simple DAE problem can 
    % become challenging to solve. This problem is introduced in :cite:p:`Asc89` 
    % to study the convergence of implcit solvers applied to DAEs.
    %
    % Notes
    % -----
    % +---------------------+-----------------------------------------+
    % | Type                | DAE                                     |
    % +---------------------+-----------------------------------------+
    % | Number of Variables | 2                                       |
    % +---------------------+-----------------------------------------+
    % | Stiff               | typically, depending on $\beta$         |
    % +---------------------+-----------------------------------------+
    %
    % Example
    % -------
    % >>> problem = otp.ascherlineardae.presets.Canonical(0.1);
    % >>> sol = problem.solve('MaxStep',1e-5);
    % >>> problem.plotPhaseSpace(sol);

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
            %
            % Returns
            % -------
            % obj : AscherLinearDAEProblem
            %    The constructed problem.
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
