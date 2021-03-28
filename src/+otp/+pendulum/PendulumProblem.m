classdef PendulumProblem < otp.Problem
    properties (SetAccess = private)
        RhsMass
    end
    
    methods
        function obj = PendulumProblem(timeSpan, y0, parameters)
            % Constructs a problem
            obj@otp.Problem('Pendulum', [], timeSpan, y0, parameters);
        end
        
        function [x, y] = convert2Cartesian(obj, y, includeOrigin)
            angles = y(1:end/2, :);
            lengths = obj.Parameters.lengths(:);
            x = cumsum(lengths .* sin(angles), 1);
            y = cumsum(-lengths .* cos(angles), 1);
            
            if nargin > 2 && includeOrigin
                z = zeros(1, size(y, 2));
                x = [z; x];
                y = [z; y];
            end
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            g = obj.Parameters.g;
            lengths = obj.Parameters.lengths(:);
            masses = obj.Parameters.masses(:);
            
            numBobs = min(numel(lengths), numel(masses));
            lengths = lengths(1:numBobs);
            masses = masses(1:numBobs);
            cumulativeMasses = cumsum(masses, 'reverse');
            
            offDiagScaling = -1 ./ (lengths(1:end-1) .* lengths(2:end) .* masses(1:end-1));
            cDiag = [1 / (lengths(1)^2 * masses(1)); (masses(1:end-1) + masses(2:end)) ./ (lengths(2:end).^2 .* masses(1:end-1) .* masses(2:end))];
            
            obj.Rhs = otp.Rhs(@(t, y) otp.pendulum.f(t, y, lengths, cumulativeMasses, g, offDiagScaling, cDiag));
            
            scaledMasses = lengths .* cumulativeMasses(max(1:numBobs, (1:numBobs).')) .* lengths.';
            
            obj.RhsMass = otp.Rhs(@(t, y) otp.pendulum.fmass(t, y, lengths, cumulativeMasses, g, scaledMasses),...
                otp.Rhs.FieldNames.Jacobian, @(t,y) otp.pendulum.jacmass(t, y, lengths, cumulativeMasses, g, scaledMasses), ...
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
            numBobs = obj.NumVars/2;
            if index <= numBobs
                label = sprintf('\\theta_{%d}', index);
            else
                label = sprintf('\\omega_{%d}', index - numBobs);
            end
        end
        
        function sol = internalSolve(obj, varargin)
            sol = internalSolve@otp.Problem(obj, 'Method', @ode45, varargin{:});
        end
        
        function mov = internalMovie(obj, t, y, varargin)
            [x, y] = obj.convert2Cartesian(y, true);
            
            mov = otp.pendulum.PendulumMovie('Title', obj.Name, varargin{:});
            mov.record(t, [x; y]);
        end
    end
end
