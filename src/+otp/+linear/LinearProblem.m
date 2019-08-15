classdef LinearProblem < otp.Problem
    properties (SetAccess = private)
        RhsPartitions
    end
    
    properties (Dependent)
        NumPartitions
    end
    
    methods
        function obj = LinearProblem(timeSpan, y0, parameters)
            obj@otp.Problem('Linear Problem', timeSpan, y0, parameters);
        end
        
        function [p] = get.NumPartitions(obj)
            p = length(obj.Parameters.A);
        end
    end
    
    methods (Access = private)
        function [rhs] = createRhs(~, A)
            rhs = otp.Rhs(@(~, y) A * y, ...
                otp.Rhs.FieldNames.Jacobian, @(~, ~) A, ...
                otp.Rhs.FieldNames.JacobianVectorProduct, @(~, ~, v) A * v, ...
                otp.Rhs.FieldNames.JacobianAdjointVectorProduct, @(~, ~, v) A' * v);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            A = obj.Parameters.A;
            
            Asum = A{1};
            for i = 2:obj.NumPartitions
                Asum = Asum + A{i};
            end            
            obj.Rhs = obj.createRhs(Asum);
            
            obj.RhsPartitions = cellfun(@obj.createRhs, A);
        end
        
        function validateNewState(obj, newTimeSpan, newY0, newParameters)
            validateNewState@otp.Problem(obj, newTimeSpan, newY0, newParameters)
            otp.utils.StructParser(newParameters).checkField('A', 'cell', ...
                @(A) all(cellfun(@(m) ismatrix(m) && isnumeric(m), A)));
        end
    end
end
