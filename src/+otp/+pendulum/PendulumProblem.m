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
            obj@otp.Problem('Pendulum',[], timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            g = obj.Parameters.g;
            lengths = obj.Parameters.lengths(:);
            masses = obj.Parameters.masses(:);
            cumulativeMasses = cumsum(masses, 'reverse');
            js = 1:min(numel(lengths), numel(masses));
            scaledMasses = lengths(js) .* cumulativeMasses(max(js, js.')) .* lengths(js).';
            
            obj.Rhs = otp.Rhs(@(t, y) otp.pendulum.f(t, y, lengths, cumulativeMasses, g, scaledMasses),...
                otp.Rhs.FieldNames.Jacobian, @(t,y) otp.pendulum.jac(t, y, lengths, cumulativeMasses, g, scaledMasses), ...
                otp.Rhs.FieldNames.Mass, @(t,y) otp.pendulum.mass(t, y, lengths, cumulativeMasses, g, scaledMasses),...
                otp.Rhs.FieldNames.MStateDependence, 'strong');
        end
        
        function validateNewState(obj, newTimeSpan, newY0, newParameters)
            validateNewState@otp.Problem(obj, newTimeSpan, newY0, newParameters)
            
            otp.utils.StructParser(newParameters) ...
                .checkField('g', 'scalar', 'real', 'finite', 'positive') ...
                .checkField('lengths', 'vector', 'real', 'finite', 'positive') ...
                .checkField('masses',  'vector', 'real', 'finite', 'positive');
        end
        
        function label = internalIndex2label(obj, index)
            numPendulums = obj.NumVars/2;
            if index <= numPendulums
                label = sprintf('\\theta_{%d}', numPendulums);
            else 
                label = sprintf('\\omega_{%d}', index - numPendulums);
            end
        end
        
        function sol = internalSolve(obj, varargin)
            sol = internalSolve@otp.Problem(obj, 'Method', @ode45, varargin{:});
        end
        
        function mov = internalMovie(obj, t, y, varargin)
            angles = y(:, 1:obj.NumVars/2);
            coords = [cumsum(sin(angles) * diag(obj.Parameters.lengths), 2), ...
                cumsum(-cos(angles) * diag(obj.Parameters.lengths), 2)];
            
            mov = otp.pendulum.PendulumMovie(obj.Name, varargin{:});
            mov.record(t, coords);
        end
    end
end
