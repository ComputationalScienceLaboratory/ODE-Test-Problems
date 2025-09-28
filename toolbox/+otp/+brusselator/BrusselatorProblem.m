classdef BrusselatorProblem < otp.Problem
    % A two-variable model for an autocatalytic reaction.
    %
    % The Brusselator chemical reaction :cite:p:`LN71` is given by
    %
    % $$
    % \ce{
    % A &-> X \\
    % B + X &-> Y + D \\
    % 2X + Y &-> 3X \\
    % X &-> E
    % }
    % $$
    %
    % With the assumption that all reaction rates are one and the concentrations of $\ce{A}$ and $\ce{B}$ are constant
    % parameters, this system can be modeled by the following two differential equations :cite:p:`HNW93` (pp. 115-116):
    %
    % $$
    % X' &= A + X^2 Y - B X - X \\
    % Y' &= B X - X^2 Y.
    % $$
    %
    % Here, $X$ and $Y$ are concentrations of autocatylitic species of interest. Equations for species $\ce{D}$ and
    % $\ce{E}$ are not necessary as they can be deduced from $X$ and $Y$.
    %
    % Notes
    % -----
    % +---------------------+-----------------------------------------+
    % | Type                | ODE                                     |
    % +---------------------+-----------------------------------------+
    % | Number of Variables | 2                                       |
    % +---------------------+-----------------------------------------+
    % | Stiff               | not typically, depending on $A$ and $B$ |
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
            % y0 : numeric(2, 1)
            %    The initial conditions.
            % parameters : otp.brusselator.BrusselatorParameters
            %    The parameters.
            
            obj@otp.Problem('Brusselator', 2, timeSpan, y0, parameters);
        end
    end
    
    properties (SetAccess = private)
        % Right-hand side containing the linear terms $[-(B + 1) X, B X]^T$.
        %
        % See Also
        % --------
        % RHSNonlinear
        RHSLinear
        
        % Right-hand side containing the nonlinear terms $[A + X^2 Y, -X^2 Y]^T$.
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
