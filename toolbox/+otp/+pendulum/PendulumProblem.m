classdef PendulumProblem < otp.Problem
    properties (SetAccess = private)
       RHSMass
    end
    
    methods
        function obj = PendulumProblem(timeSpan, y0, parameters)
            % Constructs a problem
            obj@otp.Problem('Pendulum', [], timeSpan, y0, parameters);
        end
        
        function [x, y] = convert2Cartesian(obj, y, includeOrigin)
            angles = y(1:end/2, :);
            lengths = obj.Parameters.Lengths(:);
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
            g = obj.Parameters.Gravity;
            lengths = obj.Parameters.Lengths;
            masses = obj.Parameters.Masses;
            
            numLengths = length(lengths);
            numMasses = length(masses);
            
            if obj.NumVars ~= 2 * numMasses
                warning('OTP:inconsistentNumVars', ...
                    'With %d masses, NumVars should be %d but is %d', ...
                    numMasses, 2 * numMasses, obj.NumVars);
            elseif obj.NumVars ~= 2 * numLengths
                warning('OTP:inconsistentNumVars', ...
                    'With %d lengths, NumVars should be %d but is %d', ...
                    numLengths, 2 * numLengths, obj.NumVars);
            end
            
            numBobs = min(numLengths, numMasses);
            lengths = lengths(1:numBobs);
            masses = masses(1:numBobs);
            % OCTAVE FIX: reverse flag for cumsum is not supported
            cumulativeMasses = flip(cumsum(flip(masses)));
            
            offDiagScaling = -1 ./ (lengths(1:end-1) .* lengths(2:end) .* masses(1:end-1));
            cDiag = [1 / (lengths(1)^2 * masses(1)); (masses(1:end-1) + masses(2:end)) ./ (lengths(2:end).^2 .* masses(1:end-1) .* masses(2:end))];
            
            obj.RHS = otp.RHS(@(t, y) otp.pendulum.f(t, y, lengths, cumulativeMasses, g, offDiagScaling, cDiag));
            
            scaledMasses = lengths .* cumulativeMasses(max(1:numBobs, (1:numBobs).')) .* lengths.';
            
            obj.RHSMass = otp.RHS(@(t, y) otp.pendulum.fMass(t, y, lengths, cumulativeMasses, g, scaledMasses),...
                'Jacobian', @(t,y) otp.pendulum.jacobianMass(t, y, lengths, cumulativeMasses, g, scaledMasses), ...
                'Mass', @(t,y) otp.pendulum.mass(t, y, lengths, cumulativeMasses, g, scaledMasses));
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
            sol = internalSolve@otp.Problem(obj, 'Solver', otp.utils.Solver.Nonstiff, varargin{:});
        end
        
        function mov = internalMovie(obj, t, y, varargin)
            [x, y] = obj.convert2Cartesian(y, true);
            
            mov = otp.pendulum.PendulumMovie('Title', obj.Name, varargin{:});
            mov.record(t, [x; y]);
        end
    end
end
