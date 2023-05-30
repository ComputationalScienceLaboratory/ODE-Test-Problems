classdef BrusselatorProblem < otp.Problem
    % A two-variable model for an autocatalytic reaction
    %
    %   The Brusselator chemical reaction [LN71]_ is given by
    %
    %   $$
    %   A &\to X \\
    %   B + X &\to Y + D \\
    %   2X + Y &\to 3X \\
    %   X &\to E
    %   $$
    %
    %   With the assumption that all reaction rates are one and the concentrations of $A$ and $B$ are constant
    %   parameters, this system can be modeled by the following two differential equations [HNW93]_.
    %
    %   $$
    %   X' &= 1 - (b + 1) X + a X^2 Y \\
    %   Y' &= b X - a X^2 Y
    %   $$
    %
    %   Here, $X$ and $Y$ are concentrations of autocatylitic species of interest. Equations for species $D$ and $E$ are
    %   not necessary as they can be deduced from $X$ and $Y$.
    %
    %   Notes:
    %       +---------------------+-----+
    %       | Type                | ODE |
    %       +---------------------+-----+
    %       | Number of Variables | 2   |
    %       +---------------------+-----+
    %       | Stiff               | no  |
    %       +---------------------+-----+
    %
    %   References:
    %       .. [HNW93] Hairer, E., et al. Solving Ordinary Differential Equations I. 2nd ed., Springer, 1993, pp.
    %                  115–116. https://doi.org/10.1007/978-3-540-78862-1. Springer Series in Computational Mathematics,
    %                  8.
    %
    %       .. [LN71] Lefever, R., and G. Nicolis. "Chemical Instabilities and Sustained Oscillations." Journal of
    %                 Theoretical Biology, vol. 30, no. 2, Elsevier BV, Feb. 1971, pp. 267–284.
    %                 https://doi.org/10.1016/0022-5193(71)90054-3.
    
    methods
        function obj = BrusselatorProblem(timeSpan, y0, parameters)
            % Create a Brusselator problem object
            %
            %   Parameters:
            %       timeSpan (vector): The start and final time
            %       y0 (vector): The initial conditions
            %       parameters (BrusselatorParameters): The parameters
            %
            %   Returns:
            %       BrusselatorProblem: The constructed problem
            obj@otp.Problem('Brusselator', 2, timeSpan, y0, parameters);
        end
    end
    
    properties (SetAccess = private)
        % Right-hand side containing the linear terms $[-(b + 1) X; b X]$
        %
        % See Also:
        %   :attr:`RHSNonlinear`
        RHSLinear
        
        % Right-hand side containing the nonlinear terms $[1 + a X^2 Y; -a X^2 Y]$
        %
        % See Also:
        %   :attr:`RHSLinear`
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
