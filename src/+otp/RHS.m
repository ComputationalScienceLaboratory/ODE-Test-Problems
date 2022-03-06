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
    
    properties (Dependent)
        JacobianMatrix
        JacobianFunction
        MassMatrix
        MassFunction
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
        
        function mat = get.JacobianMatrix(obj)
            mat = obj.prop2Matrix(obj.Jacobian);
        end
        
        function fun = get.JacobianFunction(obj)
            fun = obj.prop2Function(obj.Jacobian);
        end
        
        function mat = get.MassMatrix(obj)
            mat = obj.prop2Matrix(obj.Mass);
        end
        
        function fun = get.MassFunction(obj)
            fun = obj.prop2Function(obj.Mass);
        end
        
        function obj = uplus(obj)
        end
    
        function newRHS = uminus(obj)
            newRHS = mtimes(-1, obj);
        end

        function newRHS = plus(obj1, obj2)
            newRHS = applyOp(obj1, obj2, @plus, @(r, ~) r, @(~, r) r, @plus);
        end

        function newRHS = minus(obj1, obj2)
            newRHS = applyOp(obj1, obj2, @minus, @(r, ~) r, @(~, r) -r, @minus);
        end

        function newRHS = mtimes(obj1, obj2)
            newRHS = applyOp(obj1, obj2, @mtimes, @mtimes, @mtimes, []);
        end

        function newRHS = times(obj1, obj2)
            newRHS = applyOp(obj1, obj2, @times, @times, @times, []);
        end

        function newRHS = rdivide(obj1, obj2)
            newRHS = applyOp(obj1, obj2, @rdivide, @rdivide, @rdivide, []);
        end

        function newRHS = ldivide(obj1, obj2)
            newRHS = applyOp(obj1, obj2, @ldivide, @ldivide, @ldivide, []);
        end

        function newRHS = mrdivide(obj1, obj2)
            newRHS = applyOp(obj1, obj2, @mrdivide, @mrdivide, @mrdivide, []);
        end

        function newRHS = mldivide(obj1, obj2)
            newRHS = applyOp(obj1, obj2, @mldivide, @mldivide, @mldivide, []);
        end

        function newRHS = power(obj1, obj2)
            newRHS = applyOp(obj1, obj2, @power, [], [], []);
        end

        function newRHS = mpower(obj1, obj2)
            newRHS = applyOp(obj1, obj2, @mpower, [], [], []);
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
    
    methods (Access = private)
        function mat = prop2Matrix(~, p)
            if isa(p, 'function_handle')
                mat = [];
            else
                mat = p;
            end
        end
        
        function fun = prop2Function(~, p)
            if isa(p, 'function_handle') || isempty(p)
                fun = p;
            else
                fun = @(varargin) p;
            end
        end
        
        function newRHS = applyOp(obj1, obj2, op, dOpLeft, dOpRight, dOpBoth)
            if isa(obj1, 'function_handle')
                obj1 = otp.RHS(obj1);
            elseif isa(obj2, 'function_handle')
                obj2 = otp.RHS(obj2);
            end
            
            if isa(obj1, 'otp.RHS')
                primaryRHS = obj1;
                if isa(obj2, 'otp.RHS')
                    f = otp.RHS.mergeProp(obj1.F, obj2.F, op);
                    merge = @(p) otp.RHS.mergeProp(obj1.(p), obj2.(p), dOpBoth);
                    
                    if strcmp(obj1.Vectorized, obj2.Vectorized)
                        vectorized = obj1.Vectorized;
                    end
                else
                    f = otp.RHS.mergeProp(obj1.F, obj2, op);
                    merge = @(p) otp.RHS.mergeProp(obj1.(p), obj2, dOpLeft);
                    vectorized = obj1.Vectorized;
                end
            else
                primaryRHS = obj2;
                f = otp.RHS.mergeProp(obj1, obj2.F, op);
                merge = @(p) otp.RHS.mergeProp(obj1, obj2.(p), dOpRight);
                vectorized = obj2.Vectorized;
            end
            
            % Events and NonNegative practically cannot be supported and are
            % always unset.
            
            % JPattern is problematic to compute for division operators due to
            % singular patterns
            
            % Mass matrices introduce several difficulties. When singular, it
            % makes it infeasible to update InitialSlope, and therefore, it is
            % always unset. To avoid issues with two RHS' having different mass
            % matrices, only the primary RHS is used.
            
            newRHS = otp.RHS(f, ...
                'Mass', primaryRHS.Mass, ...
                'MassSingular', primaryRHS.MassSingular, ...
                'MStateDependence', primaryRHS.MStateDependence, ...
                'MvPattern', primaryRHS.MvPattern, ...
                'Jacobian', merge('Jacobian'), ...
                'JacobianVectorProduct', merge('JacobianVectorProduct'), ...
                'JacobianAdjointVectorProduct', ...
                merge('JacobianAdjointVectorProduct'), ...
                'PartialDerivativeParameters', ...
                merge('PartialDerivativeParameters'), ...
                'PartialDerivativeTime', merge('PartialDerivativeTime'), ...
                'HessianVectorProduct', merge('HessianVectorProduct'), ...
                'HessianAdjointVectorProduct', ...
                merge('HessianAdjointVectorProduct'), ...
                'Vectorized', vectorized);
        end
    end
    
    methods (Static, Access = private)
        function p = mergeProp(p1, p2, op)
            if isempty(p1) || isempty(p2) || isempty(op)
                p = [];
            elseif isa(p1, 'function_handle')
                if isa(p2, 'function_handle')
                    p = @(varargin) op(p1(varargin{:}), p2(varargin{:}));
                else
                    p = @(varargin) op(p1(varargin{:}), p2);
                end
            elseif isa(p2, 'function_handle')
                p = @(varargin) op(p1, p2(varargin{:}));
            else
                p = op(p1, p2);
            end
        end
    end
end
