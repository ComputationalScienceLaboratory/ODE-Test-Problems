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
    % fixed constant positions of $(\mu,0,0)^T$ for the first object, and
    % $(1 - \mu,0,0)^T$ for the second object. The evolution of the third
    % object of negligent mass is given by the following second-order
    % non-dimensionalized differential equation:
    %
    % $$
    % x'' &= σ(y - x),\\
    % y'' &= ρx - y - xz,\\
    % z'' &= xy - βz,\\
    % U &= \frac{1}{2} (x^2 + y^2) + \frac{1 - \mu}{d} + \frac{mu}{r},\\
    % d &= \sqrt{(x + \mu)^2 + y^2 + z^2},\\
    % r &= \sqrt{(x - 1 + \mu)^2 + y^2 + z^2},
    % $$
    %
    % where the system is converted to a differential equation in six
    % variables in the standard fashion. The distances $d$ and $r$ can
    % cause numerical instability as they approach zero, thus a softening
    % factor of $s^2$ is typically added under both of the square-roots.
    %
    % The system of equations is energy-preserving, meaning that the Jacobi
    % constant of the system,
    %
    % $$
    % J = 2U - x'^2 - y'^2 - z'^2,
    % $$
    %
    % is preserved throughout the evolution of the equations, though this
    % is typically not true numerically.
    %
    % Notes
    % -----
    % +---------------------+-----------------------------------------------+
    % | Type                | ODE                                           |
    % +---------------------+-----------------------------------------------+
    % | Number of Variables | 6                                             |
    % +---------------------+-----------------------------------------------+
    % | Stiff               | no                                            |
    % +---------------------+-----------------------------------------------+
    %
    % Example
    % -------
    % >>> problem = otp.cr3bp.presets.NRHO;
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
            % y0 : numeric(6, 1)
            %    The initial conditions.
            % parameters : otp.cr3bp.CR3BPParameters
            %    The parameters.

            obj@otp.Problem('Circular Restricted 3 Body Problem', 6, timeSpan, y0, parameters);
        end
    end

    properties (SetAccess = private)
        JacobiConstant
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            mu   = obj.Parameters.Mu;
            soft = obj.Parameters.SoftFactor;

            obj.JacobiConstant = @(y) otp.cr3bp.jacobiconstant(y, mu, soft);
            
            obj.RHS = otp.RHS(@(t, y) otp.cr3bp.f(t, y, mu, soft), ...
                'Vectorized', 'on');
        end
        
        function label = internalIndex2label(~, index)
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
            fig = internalPlotPhaseSpace@otp.Problem(obj, t, y, ...
                'Vars', 1:3, varargin{:});
            hold on;
            scatter3([mu, 1 - mu], [0, 0], [0, 0]);
        end

    end

end
