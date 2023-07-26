classdef Lorenz63Problem < otp.Problem
    % Three variable Lorenz '63 problem of the form,
    %
    % $$
    % x' = \sigma(y - x),\\
    % y' = \rho x - y - xz,\\
    % z' = xy - \beta z,
    % $$
    %
    % that exhibits chaotic behavior for certain values of the parameters.
    %
    % Here $x$ roughyl corresponds to the rate of convention of a fluid,
    % $y$ corresponds to temperature variation in one orthogonal direction,
    % and $z$ is temerature variation in the other direction.
    %
    %
    % For a full problem description take a look at the original
    % formulation in :cite:p:`Lor63`, and for a more detailed look at
    % the behavior of the problem, look at :cite:p:`Str18`.
    %
    % Notes
    % -----
    % +---------------------+-----------------------------------------------------------+
    % | Type                | ODE                                                       |
    % +---------------------+-----------------------------------------------------------+
    % | Number of Variables | 3                                                         |
    % +---------------------+-----------------------------------------------------------+
    % | Stiff               | not typically, depending on $\sigma$, $\rho$, and $\beta$ |
    % +---------------------+-----------------------------------------------------------+
    %
    % Example
    % -------
    % >>> problem = otp.lorenz63.presets.Canonical;
    % >>> sol = problem.solve('MaxStep', 1e-3);
    % >>> problem.plotPhaseSpace(sol);
    %
    % See also
    % --------
    % :doc:`Lorenz '96 Problem </problems/Lorenz96Problem>`
    
    methods
        function obj = Lorenz63Problem(timeSpan, y0, parameters)
            obj@otp.Problem('Lorenz Equations', 3, timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            sigma = obj.Parameters.Sigma;
            rho   = obj.Parameters.Rho;
            beta  = obj.Parameters.Beta;
            
            obj.RHS = otp.RHS(@(t, y) otp.lorenz63.f(t, y, sigma, rho, beta), ...
                'Jacobian',                     @(t, y) otp.lorenz63.jacobian(t, y, sigma, rho, beta), ...
                'JacobianVectorProduct',        @(t, y, v) otp.lorenz63.jacobianVectorProduct(t, y, v, sigma, rho, beta), ...
                'JacobianAdjointVectorProduct', @(t, y, v) otp.lorenz63.jacobianAdjointVectorProduct(t, y, v, sigma, rho, beta), ...
                'PartialDerivativeParameters',  @(t, y) otp.lorenz63.partialDerivativeParameters(t, y, sigma, rho, beta), ...
                'HessianVectorProduct',         @(t, y, u, v) otp.lorenz63.hessianVectorProduct(t, y, u, v, sigma, rho, beta), ...
                'HessianAdjointVectorProduct',  @(t, y, u, v) otp.lorenz63.hessianAdjointVectorProduct(t, y, u, v, sigma, rho, beta), ...
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
            end
        end
        
        function sol = internalSolve(obj, varargin)
            sol = internalSolve@otp.Problem(obj, 'Solver', otp.utils.Solver.Nonstiff, varargin{:});
        end
        
        function mov = internalMovie(obj, t, y, varargin)
            mov = otp.utils.movie.PhaseSpaceMovie('Title', obj.Name, 'Vars', 1:obj.NumVars, ...
                'xlabel', obj.index2label(1), ...
                'ylabel', obj.index2label(2), ...
                'zlabel', obj.index2label(3), ...
                varargin{:});
            mov.record(t, y);
        end
    end
end
