classdef BrusselatorProblem < otp.Problem
    % A two-variable model for an autocatalytic reaction.
    %
    % The Brusselator chemical reaction :cite:p:`LN71` is given by
    %
    % $$
    % A &\to X \\
    % B + X &\to Y + D \\
    % 2X + Y &\to 3X \\
    % X &\to E
    % $$
    %
    % With the assumption that all reaction rates are one and the concentrations of $A$ and $B$ are constant parameters,
    % this system can be modeled by the following two differential equations :cite:p:`HNW93` (pp. 115-116):
    %
    % $$
    % X' &= 1 - (b + 1) X + a X^2 Y \\
    % Y' &= b X - a X^2 Y.
    % $$
    %
    % Here, $X$ and $Y$ are concentrations of autocatylitic species of interest. Equations for species $D$ and $E$ are
    % not necessary as they can be deduced from $X$ and $Y$.
    %
    % Notes
    % -----
    % +---------------------+-----------------------------------------+
    % | Type                | ODE                                     |
    % +---------------------+-----------------------------------------+
    % | Number of Variables | 2                                       |
    % +---------------------+-----------------------------------------+
    % | Stiff               | not typically, depending on $a$ and $b$ |
    % +---------------------+-----------------------------------------+
    %
    % Example
    % -------
    % >>> problem = otp.brusselator.presets.Canonical;
    % >>> problem.TimeSpan(end) = 15;
    % >>> sol = problem.solve();
    % >>> problem.plotPhaseSpace(sol);
    
    methods
        function obj = BrusselatorProblem(timeSpan, y0, parameters)
            % Create a Brusselator problem object.
            %
            % Parameters
            % ----------
            % timeSpan : numeric(1, 2)
            %    The start and final time.
            % y0 : numeric(:, 1)
            %    The initial conditions.
            % parameters : BrusselatorParameters
            %    The parameters.
            %
            % Returns
            % -------
            % obj : BrusselatorProblem
            %    The constructed problem.
            obj@otp.Problem('Brusselator', 2, timeSpan, y0, parameters);
        end
    end
    
    properties (SetAccess = private)
        % Right-hand side containing the linear terms $[-(b + 1) X; b X]$.
        %
        % See Also
        % --------
        % RHSNonlinear
        RHSLinear
        
        % Right-hand side containing the nonlinear terms $[1 + a X^2 Y; -a X^2 Y]$.
        %
        % See Also
        % --------
        % RHSLinear
        RHSNonlinear
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            a = obj.Parameters.A;
            b = obj.Parameters.B;
            
            obj.RHS = otp.RHS(@(t, y) otp.brusselator.f(t, y, a, b), ...
                'Jacobian', @(t, y) otp.brusselator.jacobian(t, y, a, b), ...
                'JacobianVectorProduct', @(t, y, x) otp.brusselator.jacobianVectorProduct(t, y, x, a, b), ...
                'JacobianAdjointVectorProduct', ...
                @(t, y, x) otp.brusselator.jacobianAdjointVectorProduct(t, y, x, a, b), ...
                'Vectorized', 'on');
            
            obj.RHSLinear = otp.RHS(@(t, y) otp.brusselator.fLinear(t, y, a, b), ...
                'Jacobian', otp.brusselator.jacobianLinear(a, b), ...
                'Vectorized', 'on');
            
            obj.RHSNonlinear = otp.RHS(@(t, y) otp.brusselator.fNonlinear(t, y, a, b), ...
                'Jacobian', @(t, y) otp.brusselator.jacobianNonlinear(t, y, a, b), ...
                'Vectorized', 'on');
        end
        
        function label = internalIndex2label(~, index)
            if index == 1
                label = 'Reactant X';
            else
                label = 'Reactant Y';
            end
        end
        
        function sol = internalSolve(obj, varargin)
            sol = internalSolve@otp.Problem(obj, 'Solver', otp.utils.Solver.Nonstiff, varargin{:});
        end
    end
end
