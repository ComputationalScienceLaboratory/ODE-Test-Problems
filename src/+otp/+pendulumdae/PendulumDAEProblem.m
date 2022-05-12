classdef PendulumDAEProblem < otp.Problem
    %CONSTRAINEDPENDULUM PROBLEM This is a Hessenberg Index-2 DAE problem posed in terms of three constraints
    %
    
    properties (SetAccess=protected)
        RHSDifferential
        RHSAlgebraic
    end

    properties (Dependent)
      Y0Differential
      Z0Algebraic
    end

    methods
        function obj = PendulumDAEProblem(timeSpan, y0, parameters)
            obj@otp.Problem('Constrained Pendulum', 7, timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            m = obj.Parameters.Mass;
            l = obj.Parameters.Length;
            g = obj.Parameters.Gravity;

            % get initial energy
            initialconstraints = otp.pendulumdae.invariants([], obj.Y0Differential, g, m, l, 0);
            E0 = initialconstraints(3);

            % The right hand size in terms of x, y, x', y', and three control parameters z
            obj.RHS = otp.RHS(@(t, y) otp.pendulumdae.f(t, y, g, m, l, E0), ...
                'Mass', otp.pendulumdae.mass([], [], g, m, l, E0), ...
                'JacobianVectorProduct', ...
                @(t, y, v) otp.pendulumdae.jacobianVectorProduct(t, y, g, m, l, E0, v), ...
                'Vectorized', 'on');

            % Generate the constituent RHS for the differential part
            obj.RHSDifferential = otp.RHS(@(t, y) otp.pendulumdae.fDifferential(t, y, g, m, l, E0), ...
                'JacobianVectorProduct', ...
                @(t, y, v) otp.pendulumdae.jacobianDifferentialVectorProduct(t, y, g, m, l, E0, v), ...
                'Vectorized', 'on');

            % Generate the constituent RHS for the algebraic part
            obj.RHSAlgebraic = otp.RHS(@(t, y) otp.pendulumdae.invariants(t, y, g, m, l, E0), ...
                'Jacobian', @(t, y) otp.pendulumdae.invariantsJacobian(t, y, g, m, l, E0), ...
                'JacobianVectorProduct', ...
                @(t, y, v) otp.pendulumdae.invariantsJacobianVectorProduct(t, y, g, m, l, E0, v), ...
                'JacobianAdjointVectorProduct', ...
                @(t, y, v) otp.pendulumdae.invariantsJacobianAdjointVectorProduct(t, y, g, m, l, E0, v), ...
                'HessianAdjointVectorProduct', ...
                @(t, y, v, u) otp.pendulumdae.invariantsHessianAdjointVectorProduct(t, y, g, m, l, E0, v, u), ...
                'Vectorized', 'on');
        end

        function label = internalIndex2label(~, index)
            switch index
                case 1
                    label = 'x position';
                case 2
                    label = 'y position';
                case 3
                    label = 'x velocity';
                case 4
                    label = 'y velocity';
                case 5
                    label = 'Control 1';
                case 6
                    label = 'Control 2';
                case 7
                    label = 'Control 3';
            end
        end
    end

    methods
        function y0differential = get.Y0Differential(obj)
            y0differential = obj.Y0(1:4);
        end

        function z0algebraic = get.Z0Algebraic(obj)
            z0algebraic = obj.Y0(5:end);
        end
    end

end

