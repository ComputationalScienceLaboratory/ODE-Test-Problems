classdef PendulumDAEProblem < otp.Problem
    %CONSTRAINEDPENDULUM PROBLEM This is a Hessenberg Index-2 DAE problem posed in terms of three constraints
    %
    
    properties (Access=protected)
        RHSDifferential
        RHSAlgebraic
    end

    properties (Dependent)
      Y0Differential
      Z0Algebraic
    end

    methods
        function obj = PendulumDAEProblem(timeSpan, y0, parameters)
            obj@otp.Problem('Constrained Pendulum', 7, timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            m = obj.Parameters.Mass;
            l = obj.Parameters.Length;
            g = obj.Parameters.Gravity;

            % get initial energy
            initialconstraints = otp.pendulumdae.constraints([], obj.Y0Differential, g, m, l, 0);
            E0 = initialconstraints(3);
            

            % The right hand size in terms of x, y, x', y', and three control parameters z
            obj.RHS = otp.RHS(@(t, y) otp.pendulumdae.f(t, y, g, m, l, E0), ...
                'Mass', @(t, y) otp.pendulumdae.mass(t, y, g, m, l, E0));

            obj.RHSDifferential = otp.RHS(@(t, y) otp.pendulumdae.fdifferential(t, y, g, m, l, E0));

            obj.RHSAlgebraic = otp.RHS(@(t, y) otp.pendulumdae.constraints(t, y, g, m, l, E0), ...
                'Jacobian', @(t, y) otp.pendulumdae.constraintsjacobian(t, y, g, m, l, E0));
        end
    end

    methods
        function y0differential = get.Y0Differential(obj)
            y0differential = obj.Y0(1:4);
        end

        function z0algebraic = get.Z0Algebraic(obj)
            z0algebraic = obj.Y0(5:end);
        end
    end

end

