classdef PendulumDAEProblem < otp.Problem
    %CONSTRAINEDPENDULUM PROBLEM This is a Hessenberg Index-2 DAE problem posed in terms of three constraints
    %
    
    properties
        Constraints
        ConstraintsJacobian
        Z0 = [0; 0; 0];
    end

    methods
        function obj = PendulumDAEProblem(timeSpan, y0, parameters)
            obj@otp.Problem('Constrained Pendulum', 4, timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            m = obj.Parameters.Mass;
            l = obj.Parameters.Length;
            g = obj.Parameters.Gravity;

            % get initial energy
            initialconstraints = otp.constrainedpendulum.constraints([], obj.Y0, g, m, l, 0);
            E0 = initialconstraints(3);
            
            obj.RHS = otp.RHS(@(t, y) otp.constrainedpendulum.f(t, y, g, m, l, E0));

            obj.Constraints = @(t, y) otp.constrainedpendulum.constraints(t, y, g, m, l, E0);
            obj.ConstraintsJacobian = @(t, y) otp.constrainedpendulum.constraintsjacobian(t, y, g, m, l, E0);

        end
    end
end

