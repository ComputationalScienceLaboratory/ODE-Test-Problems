classdef RHS 
    properties (SetAccess = private)
        F
        
        Events
        InitialSlope
        Jacobian
        JPattern
        Mass
        MassSingular
        MStateDependence
        MvPattern
        NonNegative
        Vectorized
        
        JacobianVectorProduct
        JacobianAdjointVectorProduct
        PartialDerivativeParameters
        PartialDerivativeTime
        HessianVectorProduct
        HessianAdjointVectorProduct
        OnEvent
    end

    methods
        function obj = RHS(F, varargin)
            obj.F = F;
            extras = struct(varargin{:});
            fields = fieldnames(extras);
            
            for i = 1:length(fields)
                f = fields{i};
                obj.(f) = extras.(f);
            end
        end

        function newRHS = subsref(obj, vs)
            if strcmp(vs(1).type, '()')
                objF   = obj.F;
                newF = @(t, y) subsref(objF(t, y), vs);
                newJac = [];
                if ~isempty(obj.Jacobian)
                    newJac = @(t, y) subsref(obj.Jacobian(t, y), vs);
                end
                newJacvp = [];
                if ~isempty(obj.JacobianVectorProduct)
                    newJacvp = @(t, y, v) subsref(obj.JacobianVectorProduct(t, y, v), vs);
                end
                
                vectorized = obj.Vectorized;

                newRHS = otp.RHS(newF, ...
                    'Jacobian', newJac, ...
                    'JacobianVectorProduct', newJacvp, ...
                    'Vectorized', vectorized);
            else
                newRHS = builtin('subsref', obj, vs);
            end
        end

        function newRHS = plus(obj, other)
            objF   = obj.F;
            otherF = other.F;
            newF = @(t, y) objF(t, y) + otherF(t, y);
            newRHS = otp.RHS(newF);
        end

        function newRHS = vertcat(varargin)
            newF = @(t, y) [];

            for i = 1:numel(varargin)
                oldRHS = varargin{i};
                oldF = oldRHS.F;

                newF = @(t, y) [newF(t, y); oldF(t, y)];

            end

            newRHS = otp.RHS(newF);
        end

        function s = size(~)
            s = [1, 1];
        end
        
        function opts = odeset(obj, varargin)
            opts = odeset( ...
                'Events', obj.Events, ...
                'InitialSlope', obj.InitialSlope, ...
                'Jacobian', obj.Jacobian, ...
                'JPattern', obj.JPattern, ...
                'Mass', obj.Mass, ...
                'MassSingular', obj.MassSingular, ...
                'MStateDependence', obj.MStateDependence, ...
                'MvPattern', obj.MvPattern, ...
                'NonNegative', obj.NonNegative, ...
                'Vectorized', obj.Vectorized, ...
                varargin{:});
        end

    end

    methods (Static)
        function newRHS = empty(obj, other)
            error('');
        end
    end
end
