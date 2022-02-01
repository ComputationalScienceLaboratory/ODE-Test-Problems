classdef RHS < matlab.mixin.indexing.RedefinesParen
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
    
    methods (Access = protected)
        function newRHS = parenReference(obj, indexClass)
            objF   = obj.F;
            subst.type = '()';
            subst.subs =  indexClass.Indices;
            newF = @(t, y) subsref(objF(t, y), subst);
            newRHS = otp.RHS(newF);
        end

        function newRHS = parenAssign(~, ~,~)
            error('');
        end

        function newRHS = parenListLength(~, ~,~)
            error('');
        end

        function newRHS = parenDelete(~, ~,~)
            error('');
        end
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

        function newRHS = plus(obj, other)
            objF   = obj.F;
            otherF = other.F;
            newF = @(t, y) objF(t, y) + otherF(t, y);
            newRHS = otp.RHS(newF);
        end

        function newRHS = cat(dim, varargin)
            newF = @(t, y) [];
            if dim == 1
                for i = 1:numel(varargin)
                    oldRHS = varargin{i};
                    oldF = oldRHS.F;
                    newF = @(t, y) [newF(t, y); oldF(t, y)];
                end
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
