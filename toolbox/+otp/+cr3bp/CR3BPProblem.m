classdef CR3BPProblem < otp.Problem
    % The circular restricted three body problem
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
    % >>> sol = model.solve('AbsTol', 1e-14, 'RelTol', 100*eps);
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
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            mu   = obj.Parameters.Mu;
            soft = obj.Parameters.SoftFactor;
            
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
            sol = internalSolve@otp.Problem(obj, 'Solver', otp.utils.Solver.Nonstiff, varargin{:});
        end

    end
end
