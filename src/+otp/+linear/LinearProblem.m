classdef LinearProblem < otp.Problem
    properties (SetAccess = private)
        RhsPartitions
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
        
        function rhs = createRhs(~, A)
            rhs = otp.Rhs(@(~, y) A * y, ...
                'Jacobian', A, ...
                'JacobianVectorProduct', @(~, ~, v) A * v, ...
                'JacobianAdjointVectorProduct', @(~, ~, v) A' * v);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            obj.Rhs = obj.createRhs(obj.computeASum());
            obj.RhsPartitions = cellfun(@obj.createRhs, obj.Parameters.A);
        end
    end
end
