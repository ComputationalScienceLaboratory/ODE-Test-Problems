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
            newRHS = applyOp(obj1, obj2, @plus, 2);
        end

        function newRHS = minus(obj1, obj2)
            newRHS = applyOp(obj1, obj2, @minus, 2);
        end

        function newRHS = mtimes(obj1, obj2)
            newRHS = applyOp(obj1, obj2, @mtimes, 1);
        end

        function newRHS = times(obj1, obj2)
            newRHS = applyOp(obj1, obj2, @times, 1);
        end

        function newRHS = rdivide(obj1, obj2)
            newRHS = applyOp(obj1, obj2, @rdivide, 1);
        end

        function newRHS = ldivide(obj1, obj2)
            newRHS = applyOp(obj1, obj2, @ldivide, 1);
        end

        function newRHS = mrdivide(obj1, obj2)
            newRHS = applyOp(obj1, obj2, @mrdivide, 1);
        end

        function newRHS = mldivide(obj1, obj2)
            newRHS = applyOp(obj1, obj2, @mldivide, 1);
        end

        function newRHS = power(obj1, obj2)
            newRHS = applyOp(obj1, obj2, @power, 0);
        end

        function newRHS = mpower(obj1, obj2)
            newRHS = applyOp(obj1, obj2, @mpower, 0);
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
        function mat = prop2Matrix(~, prop)
            if isa(prop, 'function_handle')
                mat = [];
            else
                mat = prop;
            end
        end
        
        function fun = prop2Function(~, prop)
            if isa(prop, 'function_handle') || isempty(prop)
                fun = prop;
            else
                fun = @(varargin) prop;
            end
        end
        
        function newRHS = applyOp(obj1, obj2, op, differentiability)            
            % Events and NonNegative practically cannot be supported and are
            % always unset.
            
            % Mass matrices introduce several difficulties. When singular, it
            % makes it infeasible to update InitialSlope, and therefore, it is
            % always unset. To avoid issues with two RHS' having different mass
            % matrices, only the primary RHS is used.
            [~, ~, props.Mass] = getProp(obj1, obj2, 'Mass');
            [~, ~, props.MassSingular] = getProp(obj1, obj2, 'MassSingular');
            [~, ~, props.MStateDependence] = getProp(obj1, obj2, ...
                'MStateDependence');
            [~, ~, props.MvPattern] = getProp(obj1, obj2, 'MvPattern');
            
            % Merge derivatives
            props.Jacobian = mergeProp(obj1, obj2, op, differentiability, ...
                'Jacobian');
            props.JacobianVectorProduct = mergeProp(obj1, obj2, op, ...
                differentiability, 'JacobianVectorProduct');
            props.JacobianAdjointVectorProduct = mergeProp(obj1, obj2, op, ...
                differentiability, 'JacobianAdjointVectorProduct');
            props.PartialDerivativeParameters = mergeProp(obj1, obj2, op, ...
                differentiability, 'PartialDerivativeParameters');
            props.PartialDerivativeTime = mergeProp(obj1, obj2, op, ...
                differentiability, 'PartialDerivativeTime');
            props.HessianVectorProduct = mergeProp(obj1, obj2, op, ...
                differentiability, 'HessianVectorProduct');
            props.HessianAdjointVectorProduct = mergeProp(obj1, obj2, op, ...
                differentiability, 'HessianAdjointVectorProduct');
            
            % JPattern requirs a special merge function
            if differentiability == 2
                patternOp = @or;
            else
                patternOp = @(j1, j2) op(j1 ~= 0, j2 ~=0) ~= 0;
            end
            props.JPattern = mergeProp(obj1, obj2, patternOp, ...
                differentiability, 'JPattern');
            
            % Vectorization
            [v1, v2, vPrimary, numRHS] = getProp(obj1, obj2, 'Vectorized');
            if numRHS == 1 || strcmp({v1, v2}, 'on')
                props.Vectorized = vPrimary;
            end
            
            newRHS = otp.RHS(mergeProp(obj1, obj2, op, inf, 'F'), props);
        end
        
        function [obj1, obj2, primary, numRHS] = getProp(obj1, obj2, prop)
            numRHS = 1;
            
            if isa(obj1, 'otp.RHS')
                obj1 = obj1.(prop);                
                if isa(obj2, 'otp.RHS')
                    obj2 = obj2.(prop);
                    numRHS = 2;
                end
                primary = obj1;
            else
                obj2 = obj2.(prop);
                primary = obj2;
            end
        end
        
        function p = mergeProp(obj1, obj2, op, differentiability, prop)
            [p1, p2, pPrimary, numRHS] = getProp(obj1, obj2, prop);
            
            if isempty(p1) || isempty(p2) || numRHS > differentiability
                p = [];
            elseif numRHS == differentiability - 1
                p = pPrimary;
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
