classdef CR3BPProblem < otp.Problem
    % The circular restricted three body problem, following the formulation
    % presented in :cite:p:`Spr21`.
    %
    % The system represents the evolution of an object of negligent mass
    % near two large-mass objects that orbit each other a constant distance
    % apart. The ratio of the mass of the first object to the sum of the
    % total mass of the system is represented by the non-dimensional
    % constant $\mu$. The reference frame of the system is fixed to the
    % rotationg frame of the two objects, meaning that the objects have
    % fixed constant positions of $[-\mu, 0, 0]^T$ for the first object, and
    % $[1 - \mu, 0, 0]^T$ for the second object. The evolution of the third
    % object of negligent mass is given by the following second-order
    % non-dimensionalized differential equation:
    %
    % $$
    % x'' &= 2y' + \frac{\partial U}{\partial x},\\
    % y'' &= -2x' + \frac{\partial U}{\partial y},\\
    % z'' &= \frac{\partial U}{\partial z},
    % $$
    %
    % where the energy and distances are defined as,
    %
    % $$
    % U &= \frac{1}{2} (x^2 + y^2) + \frac{1 - \mu}{d} + \frac{\mu}{r},\\
    % d &= \sqrt{(x + \mu)^2 + y^2 + z^2},\\
    % r &= \sqrt{(x - 1 + \mu)^2 + y^2 + z^2},
    % $$
    %
    % and where the system is converted to a first order differential 
    % equation in six variables in the standard fashion as,
    %
    % $$
    % x' = v_x,\\
    % y' = v_y,\\
    % z' = v_z,\\
    % v_x' = x'',\\
    % v_y' = y'',\\
    % v_z' = z'',
    % $$
    %
    % where the new variables $v_x$, $v_y$, and $v_z$ represent the
    % velocity vector.
    % 
    % The distances $d$ and $r$ can cause numerical instability as they 
    % approach zero, thus a softening factor of $s^2$ is typically added 
    % under both of the square-roots of the distances $d$ and $r$.
    %
    % When the object under consideration is on an orbit that is co-planar
    % to the orbit of the two other objects, then the system of equations
    % can reduce by two dimensions, removing the $z''$ and $z'$ terms.
    %
    % The system of equations is energy-preserving, meaning that the Jacobi
    % constant of the system,
    %
    % $$
    % J = 2U - v_x^2 - v_y^2 - v_z^2,
    % $$
    %
    % is preserved throughout the evolution of the equations, though this
    % is typically not true numerically. The Jacobi constant is provided as
    % a function.
    %
    % For state estimation purposes a radar measurement is also provided,
    %
    % $$
    % h(x, y, z, v_x, v_y, v_z) = \begin{bmatrix}
    % \sqrt{(x - s_x)^2 + (y - s_y)^2 + (z - s_z)^2}\\
    % \frac{(x - s_x) \cdot v_x + (y - s_y) \cdot v_y + (z - s_z) \cdot v_z}
    % {\sqrt{(x - s_x)^2 + (y - s_y)^2 + (z - s_z)^2}}\\
    % \tan^{-1} \frac{y}{x + \mu}\\
    % \tan^{-1} \frac{z}{\sqrt{(x - s_x)^2 + (y - s_y)^2 + (z - s_z)^2}}
    % \end{bmatrix}
    % $$
    %
    % where $s_x$, $s_y$, and $s_z$ are the locations of the radar sensor,
    % the first term is the range to the object from the sensor, the second
    % term is the rate of change of the range (range-rate), and the third
    % and fourth terms are the two angles the radar must be pointing. In
    % the planar case, the fourth term is absent.
    %
    % Notes
    % -----
    % +---------------------+-----------------------------------------------+
    % | Type                | ODE                                           |
    % +---------------------+-----------------------------------------------+
    % | Number of Variables | 4 for planar or 6 for non-planar              |
    % +---------------------+-----------------------------------------------+
    % | Stiff               | no                                            |
    % +---------------------+-----------------------------------------------+
    %
    % Example
    % -------
    % >>> problem = otp.circularrestricted3body.presets.HaloOrbit('OrbitType', 'L2', 'Index', 10);
    % >>> sol = model.solve();
    % >>> problem.plotPhaseSpace(sol);
    %
    % See Also
    % --------
    % otp.nbody.NBodyProblem
    
    methods
        function obj = CR3BPProblem(timeSpan, y0, parameters)
            % Create a CR3BP problem object.
            %
            % Parameters
            % ----------
            % timeSpan : numeric(1, 2)
            %    The start and final time.
            % y0 : numeric(n, 1)
            %    The initial conditions. Either n = 4 or n = 6.
            % parameters : otp.circularrestricted3body.CR3BPParameters
            %    The parameters.

            obj@otp.Problem('Circular Restricted 3 Body Problem', [], timeSpan, y0, parameters);
        end
    end

    properties (SetAccess = private)
        JacobiConstant
        JacobiConstantJacobian
        RadarMeasurement
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            mu         = obj.Parameters.Mu;
            soft       = obj.Parameters.SoftFactor;

            spatialdim = numel(obj.Y0)/2;
            if ~(spatialdim == 2 || spatialdim == 3)
                error('OTP:invalidY0', 'Expected Y0 to have 4 or 6 components but has %d', numel(obj.Y0));
            end

            if spatialdim == 3
                obj.JacobiConstant = @(y) otp.circularrestricted3body.jacobiConstant(y, mu, soft);
                obj.JacobiConstantJacobian = @(y) otp.circularrestricted3body.jacobiConstantJacobian(y, mu, soft);

                obj.RadarMeasurement = @(y, radary) otp.circularrestricted3body.radarMeasurement(t, y, mu, soft, radary);

                obj.RHS = otp.RHS(@(t, y) otp.circularrestricted3body.f(t, y, mu, soft), ...
                    'Jacobian', ...
                    @(t, y) otp.circularrestricted3body.jacobian(t, y, mu, soft), ...
                    'JacobianVectorProduct', ...
                    @(t, y, v) otp.circularrestricted3body.jacobianVectorProduct(t, y, v, mu, soft), ...
                    'Vectorized', ...
                    'on');
            else
                obj.JacobiConstant = @(y) otp.circularrestricted3body.jacobiConstantPlanar(y, mu, soft);
                obj.JacobiConstantJacobian = @(y) otp.circularrestricted3body.jacobiConstantJacobianPlanar(y, mu, soft);

                obj.RadarMeasurement = @(y, radary) otp.circularrestricted3body.radarMeasurementPlanar(t, y, mu, soft, radary);

                obj.RHS = otp.RHS(@(t, y) otp.circularrestricted3body.fPlanar(t, y, mu, soft), ...
                    'Jacobian', ...
                    @(t, y) otp.circularrestricted3body.jacobianPlanar(t, y, mu, soft), ...
                    'JacobianVectorProduct', ...
                    @(t, y, v) otp.circularrestricted3body.jacobianVectorProductPlanar(t, y, v, mu, soft), ...
                    'Vectorized', ...
                    'on');
            end
        end

        function label = internalIndex2label(obj, index)
            if numel(obj.Y0) == 6
                switch index
                    case 1
                        label = 'x';
                    case 2
                        label = 'y';
                    case 3
                        label = 'z';
                    case 4
                        label = 'dx';
                    case 5
                        label = 'dy';
                    case 6
                        label = 'dz';
                end
            elseif numel(obj.Y0) == 4
                switch index
                    case 1
                        label = 'x';
                    case 2
                        label = 'y';
                    case 3
                        label = 'dx';
                    case 4
                        label = 'dy';
                end
            end
        end
        
        function sol = internalSolve(obj, varargin)
            sol = internalSolve@otp.Problem(obj, ...
                'Solver', otp.utils.Solver.Nonstiff, ...
                'AbsTol', 1e-14, ...
                'RelTol', 100*eps, ...
                varargin{:});
        end

        function fig = internalPlotPhaseSpace(obj, t, y, varargin)
            mu   = obj.Parameters.Mu;

            if numel(obj.Y0) == 6
                fig = internalPlotPhaseSpace@otp.Problem(obj, t, y, ...
                    'Vars', 1:3, varargin{:});
                hold on;
                scatter3([-mu, 1 - mu], [0, 0], [0, 0]);
                axis equal
            elseif numel(obj.Y0) == 4
                fig = internalPlotPhaseSpace@otp.Problem(obj, t, y, ...
                    'Vars', 1:2, varargin{:});
                hold on;
                scatter([-mu, 1 - mu], [0, 0]);
                axis equal
            end
        end

    end

end
