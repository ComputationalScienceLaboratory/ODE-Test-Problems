classdef LinearProblem < otp.Problem
    properties (SetAccess = private)
       RHSPartitions
    end
    
    properties (Dependent)
        NumPartitions
    end
    
    methods
        function obj = LinearProblem(timeSpan, y0, parameters)
            obj@otp.Problem('Linear Problem', [], timeSpan, y0, parameters);
        end
        
        function p = get.NumPartitions(obj)
            p = length(obj.Parameters.A);
        end
    end
    
    methods (Access = private)
        function Asum = computeASum(obj)
            Asum = obj.Parameters.A{1};
            for i = 2:obj.NumPartitions
                Asum = Asum + obj.Parameters.A{i};
            end
        end
        
        function rhs = createRHS(~, A)
            rhs = otp.RHS(@(~, y) A * y, ...
                'Jacobian', A, ...
                'JacobianVectorProduct', @(~, ~, v) A * v, ...
                'JacobianAdjointVectorProduct', @(~, ~, v) A' * v);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            obj.RHS = obj.createRHS(obj.computeASum());
            % Octave doesn't support class arrays so nonuniform output
            obj.RHSPartitions = cellfun(@obj.createRHS, obj.Parameters.A, ...
                'UniformOutput', false);
        end
        
        function y = internalSolveExactly(obj, t)
            numT = length(t)
            for i = 1:numT
                yi = expm((t(i) - obj.TimeSpan(1)) * obj.RHS.Jacobian) * obj.Y0;
                
                if i == 1
                    % The first yi provides the data type. Simply repeat vector for allocation
                    y = repmat(yi, 1, numT);
                else
                    y(:, i) = yi;
                end
            end
        end
    end
end
