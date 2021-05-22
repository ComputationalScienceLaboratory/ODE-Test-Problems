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
        RhsLinear
        RhsNonlinear
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            a = obj.Parameters.a;
            b = obj.Parameters.b;
            
            obj.Rhs = otp.Rhs(@(t, y) otp.brusselator.f(t, y, a, b), ...
                otp.Rhs.FieldNames.Jacobian, @(t, y) otp.brusselator.jac(t, y, a, b), ...
                otp.Rhs.FieldNames.JacobianVectorProduct, @(t, y, x) otp.brusselator.jvp(t, y, x, a, b), ...
                otp.Rhs.FieldNames.JacobianAdjointVectorProduct, @(t, y, x) otp.brusselator.javp(t, y, x, a, b));
            
            obj.RhsLinear = otp.Rhs(@(t, y) otp.brusselator.flinear(t, y, a, b), ...
                otp.Rhs.FieldNames.Jacobian, otp.brusselator.jaclinear(a, b));
            
            obj.RhsNonlinear = otp.Rhs(@(t, y) otp.brusselator.fnonlinear(t, y, a, b), ...
                otp.Rhs.FieldNames.Jacobian, @(t, y) otp.brusselator.jacnonlinear(t, y, a, b));
        end
        
        function validateNewState(obj, newTimeSpan, newY0, newParameters)
            validateNewState@otp.Problem(obj, newTimeSpan, newY0, newParameters)
            
            otp.utils.StructParser(newParameters) ...
                .checkField('a', 'scalar', 'real', 'finite', 'positive') ...
                .checkField('b', 'scalar', 'real', 'finite', 'positive');
        end
        
        function label = internalIndex2label(~, index)
            if index == 1
                label = 'Reactant X';
            else
                label = 'Reactant Y';
            end
        end
        
        function sol = internalSolve(obj, varargin)
            sol = internalSolve@otp.Problem(obj, 'Method', @ode45, varargin{:});
        end
    end
end
