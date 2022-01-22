classdef BrusselatorProblem < otp.Problem
    % BrusselatorProblem A two-variable model for a system of autocatalytic
    %   reaction equations
    %
    %        A → X
    %    B + X → Y + D
    %   2X + Y → 3X
    %        X → E
    %
    %   This system can be reduced to the following two equations
    %
    %   X' = 1 - (b + 1)X + aX²Y
    %   Y' = bX - aX²Y
    %
    %   where a and b are scalings such as to combine the concentrations of
    %   the excess reactants A and B and the reaction rates.
    %
    %   Bibliography:
    %   Ault, Shaun, and Erik Holmgreen. "Dynamics of the Brusselator."
    %   Math 715 Projects (Autumn 2002) (2003): 2.
    
    methods
        function obj = BrusselatorProblem(timeSpan, y0, parameters)
            % Constructs a problem
            obj@otp.Problem('Brusselator', 2, timeSpan, y0, parameters);
        end
    end
    
    properties (SetAccess = private)
       RHSLinear
       RHSNonlinear
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            a = obj.Parameters.A;
            b = obj.Parameters.B;
            
            obj.RHS = otp.RHS(@(t, y) otp.brusselator.f(t, y, a, b), ...
                'Jacobian', @(t, y) otp.brusselator.jacobian(t, y, a, b), ...
                'JacobianVectorProduct', @(t, y, x) otp.brusselator.jacobianVectorProduct(t, y, x, a, b), ...
                'JacobianAdjointVectorProduct', @(t, y, x) otp.brusselator.jacobianAdjointVectorProduct(t, y, x, a, b), ...
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
