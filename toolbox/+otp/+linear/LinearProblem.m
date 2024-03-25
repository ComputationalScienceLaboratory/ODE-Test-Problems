classdef LinearProblem < otp.Problem
    properties (SetAccess = private)
       RHSPartitions
    end
    
    properties (Dependent)
        NumPartitions
    end
    
    methods
        function obj = LinearProblem(timeSpan, y0, parameters)
            obj@otp.Problem('Linear', [], timeSpan, y0, parameters);
        end
        
        function p = get.NumPartitions(obj)
            p = length(obj.Parameters.Lambda);
        end
    end
    
    methods (Access = private)
        function lambdaSum = computeASum(obj)
            lambdaSum = obj.Parameters.Lambda{1};
            for i = 2:obj.NumPartitions
                lambdaSum = lambdaSum + obj.Parameters.Lambda{i};
            end
        end
        
        function rhs = createRHS(~, lambda)
            rhs = otp.RHS(@(~, y) lambda * y, ...
                'Jacobian', lambda, ...
                'JacobianVectorProduct', @(~, ~, v) lambda * v, ...
                'JacobianAdjointVectorProduct', @(~, ~, v) lambda' * v, ...
                'Vectorized', 'on');
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            obj.RHS = obj.createRHS(obj.computeASum());
            % OCTAVE FIX: class arrays are not supported so a cell array must be use
            obj.RHSPartitions = cellfun(@obj.createRHS, obj.Parameters.Lambda, 'UniformOutput', false);
        end
        
        function y = internalSolveExactly(obj, t)
            for i = length(t):-1:1
                y(:, i) = expm((t(i) - obj.TimeSpan(1)) * obj.RHS.Jacobian) * obj.Y0;
            end
        end
    end
end
