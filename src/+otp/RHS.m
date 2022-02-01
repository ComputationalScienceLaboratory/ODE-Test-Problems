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

        function newRHS = plus(obj, other)
            objF   = obj.F;
            otherF = other.F;
            newF = @(t, y) objF(t, y) + otherF(t, y);
            newRHS = otp.RHS(newF);
        end

        function newRHS = subsref(obj, vs)
            if vs.type == '.'
                newRHS = obj.(vs.subs);
            else
                objF   = obj.F;
                newF = @(t, y) subsref(objF(t, y), vs);
                newRHS = otp.RHS(newF);
            end
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
end
