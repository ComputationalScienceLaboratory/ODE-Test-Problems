classdef PendulumProblem < otp.Problem
    % PendulumProblem A two-variable model for the trajectory of a pendulum
    %
    %
    %   This system can be reduced to the following two equations
    %
    %   theta' = omega
    %   omega' = -g/l * sin(theta)
    %
    %   where g is the gravitational constant, l is the length of
    %   the pendulum, and theta is the angle between the pendulum and
    %   y-axis.
     
    methods
        function obj = PendulumProblem(timeSpan, y0, parameters)
            % Constructs a problem
            obj@otp.Problem('Pendulum', 2, timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            g = obj.Parameters.g;
            l = obj.Parameters.l;
            
            obj.Rhs = otp.Rhs(@(t, y) otp.pendulum.f(t, y, g, l), ...
                otp.Rhs.FieldNames.Jacobian, @(t, y) otp.pendulum.jac(t, y, g, l));
        end
        
        function validateNewState(obj, newTimeSpan, newY0, newParameters)
            validateNewState@otp.Problem(obj, newTimeSpan, newY0, newParameters)
            
            otp.utils.StructParser(newParameters) ...
                .checkField('g', 'scalar', 'real', 'finite', 'positive') ...
                .checkField('l', 'scalar', 'real', 'finite', 'positive');
        end
        
        function label = internalIndex2label(~, index)
            if index == 1
                label = 'Theta';
            else
                label = 'Omega';
            end
        end
        
        function sol = internalSolve(obj, varargin)
            sol = internalSolve@otp.Problem(obj, 'Method', @ode45, varargin{:});
        end
    end
end