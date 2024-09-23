classdef Lorenz96Problem <  otp.Problem
    % A chaotic system modeling nonlinear transfer of a dimensionless quantity along a cyclic one dimensional domain.
    % 
    % The $N$ variable dynamics :cite:p:`Lor96` are represented by the equation,
    %
    % $$
    % y_i' = -y_{i-1} (y_{i-2} - y_{i+1}) - y_i + f(t), \qquad i = 1, …, N,
    % $$
    % 
    % where $y_0 = y_N$, $y_{-1} = y_{N - 1}$, and $y_{N + 1} = y_2$, exhibits chaotic behavior for certain pairs of
    % values of the dimension $N$ and forcing function $f$.
    %
    % Notes
    % -----
    % +---------------------+----------------------------------------------+
    % | Type                | ODE                                          |
    % +---------------------+----------------------------------------------+
    % | Number of Variables | $N$ for any positive integer four or greater |
    % +---------------------+----------------------------------------------+
    % | Stiff               | no                                           |
    % +---------------------+----------------------------------------------+
    %
    % Example
    % -------
    % >>> problem = otp.lorenz96.presets.Canonical('Forcing', @(t) 8 + 4*sin(t));
    % >>> sol = problem.solve();
    % >>> problem.movie(sol);
    %
    % See Also
    % --------
    % otp.lorenz63.Lorenz63Problem
    
    properties (SetAccess = private)
        DistanceFunction
    end
    
    methods
        function obj = Lorenz96Problem(timeSpan, y0, parameters)
            % Create a Lorenz '96 problem object.
            %
            % Parameters
            % ----------
            % timeSpan : numeric(1, 2)
            %    The start and final time.
            % y0 : numeric(:, 1)
            %    The initial conditions.
            % parameters : Lorenz96Parameters
            %    The parameters.

            obj@otp.Problem('Lorenz 96', [], timeSpan, y0, parameters);
        end
    end
    
    methods (Access=protected)
        function obj = onSettingsChanged(obj)
            forcing = obj.Parameters.F;
            
            if isa(forcing, 'function_handle')
                f = @(t, y) otp.lorenz96.f(t, y, forcing);
            else
                f = @(t, y) otp.lorenz96.fConst(t, y, forcing);
            end
            
            obj.RHS = otp.RHS(f, ...
                'Jacobian', ...
                @(t, y) otp.lorenz96.jacobian(t, y), ...
                'JacobianVectorProduct', ...
                @(t, y, u) otp.lorenz96.jacobianVectorProduct(t, y, u), ...
                'JacobianAdjointVectorProduct', ...
                @(t, y, u) otp.lorenz96.jacobianAdjointVectorProduct(t, y, u), ...
                'HessianVectorProduct', ...
                @(t, y, u, v) otp.lorenz96.hessianVectorProduct(t, y, u, v), ...
                'HessianAdjointVectorProduct', ...
                @(t, y, u, v) otp.lorenz96.hessianAdjointVectorProduct(t, y, u, v), ...
                'Vectorized', 'on');
            
            % We also provide a canonical distance function as is standard for
            % localization in Data Assimilation. This is heavily tied to this
            % problem.
            
            obj.DistanceFunction = @otp.lorenz96.distanceFunction;
        end
        
        function sol = internalSolve(obj, varargin)
            sol = internalSolve@otp.Problem(obj, ...
                'Solver', otp.utils.Solver.Nonstiff, varargin{:});
        end
        
        function mov = internalMovie(obj, t, y, varargin)
            mov = otp.utils.movie.LineMovie('title', obj.Name, varargin{:});
            mov.record(t, y);
        end
    end
end
