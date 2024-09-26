classdef RHS
    % The right-hand side and related properties of a differential equation.
    %
    % This immutable class contains properties required by time integrators and other numerical methods to describe the
    % following differential equation:
    %
    % $$M(t, y) y' = f(t, y)$$
    %
    % The mass matrix $M(t, y)$ is permitted to be singular in which case the problem is a differential-algebraic
    % equation. ``RHS`` includes most of the properties available in
    % `odeset <https://www.mathworks.com/help/matlab/ref/odeset.html>`_ so that it can easily be used with built-in ODE
    % solvers.
    %
    % Examples
    % --------
    % >>> rhs = otp.RHS(@(t, y) [y(2) + t; y(1) * y(2)], ...
    % ...     'Jacobian', @(~, y) [0, 1; y(2), y(1)], ...
    % ...     'Mass', [1, 2; 3, 4]);
    % >>> sol = ode23s(rhs.F, [0, 1], [1, -1], rhs.odeset());
    % >>> sol.y(:, end)
    % ans =
    % <BLANKLINE>
    %    1.0770
    %   -1.4465
    %
    % >>> rhs = otp.RHS(@(~, y) y);
    % >>> rhs2 = 2 * rhs + 1;
    % >>> rhs2.F(0, 1)
    % ans = 3
    %
    % See Also
    % --------
    % otp.Problem.RHS
    %
    % odeset : https://www.mathworks.com/help/matlab/ref/odeset.html

    properties (SetAccess = private)
        % The function handle for $f$ in the differential equation $M(t, y) y' = f(t, y)$.
        %
        % Parameters
        % ----------
        % t : numeric
        %    The time at which $f$ is evaluated.
        % y : numeric(:, 1) or numeric(:, :)
        %    The state at which $f$ is evaluated. If :attr:`Vectorized` in ``'on'``, it can be a matrix where each
        %    column is a state.
        %
        % Returns
        % -------
        % f : numeric(:, 1) or numeric(:, :)
        %    The evaluation of $f$ with each column corresponding to a column of $y$.
        F

        % The partial derivative of $f$ with respect to $y$.
        %
        % This follows the same specifications as in `odeset <https://www.mathworks.com/help/matlab/ref/odeset.html>`_.
        % If set, it is a matrix if it is independent of t and y or a function handle. In either case, it provides a
        % square matrix in which element $(i,j)$ is $\frac{\partial f_i(t, y)}{\partial y_j}$. If ``Jacobian`` is a
        % function handle, it has the following signature:
        %
        % Parameters
        % ----------
        % t : numeric
        %    The time at which the Jacobian is evaluated.
        % y : numeric(:, 1)
        %    The state at which the Jacobian is evaluated.
        %
        % Returns
        % -------
        % jacobian : numeric(:, :)
        %    The evaluation of the Jacobian.
        %
        % See Also
        % --------
        % JacobianMatrix
        % JacobianFunction
        Jacobian

        % The sparsity pattern of the Jacobian matrix.
        %
        % This follows the same specifications as in `odeset <https://www.mathworks.com/help/matlab/ref/odeset.html>`_.
        JPattern

        % The mass matrix $M(t, y)$.
        %
        % This follows the same specifications as in `odeset <https://www.mathworks.com/help/matlab/ref/odeset.html>`_.
        %
        % See Also
        % --------
        % MassMatrix
        % MassFunction
        Mass

        % Whether the mass matrix is singular, i.e., the problem is a differential-algebraic equation.
        %
        % This follows the same specifications as in `odeset <https://www.mathworks.com/help/matlab/ref/odeset.html>`_.
        MassSingular

        % State dependence of the mass matrix.
        %
        % This follows the same specifications as in `odeset <https://www.mathworks.com/help/matlab/ref/odeset.html>`_.
        MStateDependence

        % The sparsity pattern of $\frac{\partial}{\partial y} M(t, y) v$.
        %
        % This follows the same specifications as in `odeset <https://www.mathworks.com/help/matlab/ref/odeset.html>`_.
        MvPattern

        % A vector of solution components which should be nonnegative.
        %
        % This follows the same specifications as in `odeset <https://www.mathworks.com/help/matlab/ref/odeset.html>`_.
        NonNegative

        % Whether $f$ can be evaluated at multiple states.
        %
        % This follows the same specifications as in `odeset <https://www.mathworks.com/help/matlab/ref/odeset.html>`_.
        %
        % Warning
        % -------
        % In Octave, this is always unset because it is not used by built in solvers and causes an error for ``ode15s``.
        Vectorized

        % A function which detects events and determines whether to terminate the integration.
        %
        % This follows the same specifications as in `odeset <https://www.mathworks.com/help/matlab/ref/odeset.html>`_.
        Events

        % Response to a terminal event occuring.
        %
        % If set, it is a function handle with the following signature:
        %
        % Parameters
        % ----------
        % sol : struct
        %    The solution generated by an ODE solver once an event occurs.
        % problem : Problem
        %    The problem for which the event occured. This should not be modified by the function.
        %
        % Returns
        % -------
        % terminal : logical
        %    ``true`` if the integration should stop and ``false`` if it can continue.
        % newProblem : Problem
        %    A new Problem to use after the event, possibly with the time span, initial conditions, or parameters
        %    updated.
        %
        % Warning
        % -------
        % With Octave solvers, event data in ``sol`` is transposed compared to MATLAB. Therefore, we recommend accessing
        % the state at which the event occured with ``sol.y(:, end)`` as opposed to ``sol.ye(:, end)``.
        OnEvent
        
        % The action of the Jacobian multiplying a vector.
        %
        % This offers an alternative approach to access the Jacobian when constructing or storing it as a matrix is
        % impractical. If set, it is a function handle with the following signature:
        %
        % Parameters
        % ----------
        % t : numeric
        %    The time at which the Jacobian is evaluated.
        % y : numeric(:, 1)
        %    The state at which the Jacobian is evaluated.
        % v : numeric(:, 1)
        %    The vector multiplying the Jacobian.
        %
        % Returns
        % -------
        % jvp : numeric(:, 1)
        %    A vector in which element $i$ is $\sum_j \frac{\partial f_i(t, y)}{\partial y_j} v_j$.
        JacobianVectorProduct
        
        % The action of the adjoint (conjugate transpose) of the Jacobian multiplying a vector.
        %
        % This is often useful for sensitivity analysis and data assimilation. If set, it is a function handle with the
        % following signature:
        %
        % Parameters
        % ----------
        % t : numeric
        %    The time at which the Jacobian is evaluated.
        % y : numeric(:, 1)
        %    The state at which the Jacobian is evaluated.
        % v : numeric(:, 1)
        %    The vector multiplying the adjoint of the Jacobian.
        %
        % Returns
        % -------
        % javp : numeric(:, 1)
        %    A vector in which element $i$ is $\sum_j \frac{\partial \overline{f_j(t, y)}}{\partial y_i} v_j$.
        JacobianAdjointVectorProduct

        % The partial derivative of $f$ with respect to parameters.
        %
        % If set, it is a function handle with the following signature:
        %
        % Parameters
        % ----------
        % t : numeric
        %    The time at which the derivative is evaluated.
        % y : numeric(:, 1)
        %    The state at which the derivative is evaluated.
        %
        % Returns
        % -------
        % pdp : numeric(:, :)
        %    A matrix in which element $(i, j)$ is $\frac{\partial f_i(t, y; p)}{\partial p_j}$.
        PartialDerivativeParameters

        % The partial derivative of $f$ with respect to $t$.
        %
        % This property is often required by Rosenbrock methods when solving nonautonomous problems. If set, it is a
        % function handle with the following signature:
        %
        % Parameters
        % ----------
        % t : numeric
        %    The time at which the derivative is evaluated.
        % y : numeric(:, 1)
        %    The state at which the derivative is evaluated.
        %
        % Returns
        % -------
        % pdt : numeric(:, 1)
        %    A vector in which element $i$ is $\frac{\partial f_i(t, y)}{\partial t}$.
        %
        % Note
        % ----
        % This is not the total derivative with respect to $t$.
        PartialDerivativeTime

        % The action of the Hessian, a bilinear operator involving second derivatives of $f$, on two vectors.
        %
        % If set, it is a function handle with the following signature:
        %
        % Parameters
        % ----------
        % t : numeric
        %    The time at which the Hessian is evaluated.
        % y : numeric(:, 1)
        %    The state at which the Hessian is evaluated.
        % u, v : numeric(:, 1)
        %    The vectors applied to the Hessian.
        %
        % Returns
        % -------
        % hvp : numeric(:, 1)
        %    A vector in which element $i$ is
        %    $\sum_{j,k} \frac{\partial^2 f_i(t, y)}{\partial y_j \partial y_k} u_j v_k$.
        HessianVectorProduct

        % The action of a vector on the partial derivative of :attr:`JacobianAdjointVectorProduct` with respect to $y$.
        %
        % If set, it is a function handle with the following signature:
        %
        % Parameters
        % ----------
        % t : numeric
        %    The time at which the Hessian is evaluated.
        % y : numeric(:, 1)
        %    The state at which the Hessian is evaluated.
        % u, v : numeric(:, 1)
        %    The vectors applied to the adjoint of the Hessian.
        %
        % Returns
        % -------
        % havp : numeric(:, 1)
        %    A vector in which element $i$ is
        %    $\sum_{j,k} \frac{\partial^2 \overline{f_j(t, y)}}{\partial y_i \partial y_k} u_j v_k$.
        HessianAdjointVectorProduct
    end
    
    properties (Dependent)
        % A dependent property which retruns :attr:`Jacobian` if it is a matrix and ``[]`` if it is a function handle.
        JacobianMatrix

        % A dependent property which wraps :attr:`Jacobian` in a function handle if necessary.
        JacobianFunction

        % A dependent property which retruns :attr:`Mass` if it is a matrix and ``[]`` if it is a function handle.
        MassMatrix

        % A dependent property which wraps :attr:`Mass` in a function handle if necessary.
        MassFunction
    end

    methods
        function obj = RHS(F, varargin)
            % Create a right-hand side object.
            %
            % Parameters
            % ----------
            % F : function_handle
            %    The function handle for $f$ in the differential equation $M(t, y) y' = f(t, y)$.
            % varargin
            %    A variable number of name-value pairs. A name can be any property of this class, and the subsequent
            %    value initializes that property.
            %
            % Warning
            % -------
            % In Octave, the value for :attr:`Vectorized` is ignored because it is not used by built in solvers and
            % causes an error for ``ode15s``.

            obj.F = F;
            if mod(nargin, 2) == 0
                error('OTP:invalidArgument', 'Arguments to RHS should be F followed by name-value pairs');
            end
            
            for i = 1:2:(nargin - 1)
                obj.(varargin{i}) = varargin{i + 1};
            end
            
            % OCTAVE FIX: ode15s throws an error when the Vectorized option is set. It seems no
            % integrator uses this option anyway.
            if otp.utils.compatibility.isOctave()
                obj.Vectorized = [];
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
            % Convert an ``RHS`` to a struct which can be used by built-in ODE solvers.
            %
            % Parameters
            % ----------
            % varargin
            %    Additional name-value pairs which have precedence over the values in this class.
            %
            % Returns
            % -------
            % opts : struct
            %    An options strucutre containing the subset of properties compatible with built-in ODE solvers.

            opts = odeset( ...
                'Events', obj.Events, ...
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
            
            % Events and NonNegative practically cannot be supported and are always unset.
            % JPattern is problematic to compute for division operators due to singular patterns
            % To avoid issues with two RHS' having different mass matrices, only the primary RHS is used.
            
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
