classdef BrusselatorProblem < otp.Problem
    %BRUSSELATORPROBLEM A two-variable model for an autocatalytic reaction
    %   The Brusselator chemical reaction is given by
    %
    %        A → X
    %    B + X → Y + D
    %   2X + Y → 3X
    %        X → E
    %
    %   With the assumption that all reaction rates are one and the concentrations of A and B are constant parameters,
    %   this system can be modeled by the following two differential equations.
    %
    %   X' = 1 - (b + 1)X + aX²Y
    %   Y' = bX - aX²Y
    %
    %   Here, X and Y are concentrations of autocatylitic species of interest. Equations for species D and E are not
    %   necessary as they can be deduced from X and Y.
    %
    %   Problem Properties:
    %       Type: ODE
    %       Number of Variables: 2
    %       Stiff: no
    %
    %   References:
    %   Lefever, R., and G. Nicolis. "Chemical Instabilities and Sustained Oscillations." Journal of Theoretical
    %   Biology, vol. 30, no. 2, Elsevier BV, Feb. 1971, pp. 267–284. https://doi.org/10.1016/0022-5193(71)90054-3.
    %   
    %   Hairer, E., et al. Solving Ordinary Differential Equations I. 2nd ed., Springer, 1993, pp. 115–116.
    %   https://doi.org/10.1007/978-3-540-78862-1. Springer Series in Computational Mathematics, 8.
    %
    %   See also otp.brusselator.BrusselatorParameters, otp.Problem
    
    methods
        function obj = BrusselatorProblem(timeSpan, y0, parameters)
            %BRUSSELATORPROBLEM Create a Brusselator problem object
            %   OBJ = BrusselatorProblem(TIMESPAN, Y0, PARAMETERS) constructs a BRUSSELATORPROBLEM with time span
            %   TIMESPAN, initial condition Y0, and parameters PARAMETERS. PARAMETERS should be of type
            %   otp.brusselator.BrusselatorParameters.
            %
            %   See also otp.brusselator.BrusselatorParameters, otp.Problem
            obj@otp.Problem('Brusselator', 2, timeSpan, y0, parameters);
        end
    end
    
    properties (SetAccess = private)
        %RHSLINEAR Right-hand side containing the linear terms [-(b + 1)X; bX]
        %   See also otp.brusselator.BrusselatorProblem.RHSNonlinear, otp.RHS
        RHSLinear
        
        %RHSNONLINEAR Right-hand side containing the nonlinear terms [1 + aX²Y; -aX²Y]
        %   See also otp.brusselator.BrusselatorProblem.RHSLinear, otp.RHS
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
