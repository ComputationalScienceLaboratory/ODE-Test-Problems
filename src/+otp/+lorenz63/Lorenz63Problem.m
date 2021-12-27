classdef Lorenz63Problem < otp.Problem
    
    % For a full problem description take a look at the original formulation in
    %
    %  Lorenz, Edward N. "Deterministic nonperiodic flow."
    %  Journal of the atmospheric sciences 20, no. 2 (1963): 130-141.
    %
    % For a more detailed description also take a look at
    %
    %  Strogatz, Steven H. Nonlinear dynamics and chaos: with applications to
    %  physics, biology, chemistry, and engineering. Westview press, 2014.
    
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
            
            obj.Rhs = otp.Rhs(@(t, y) otp.lorenz63.f(t, y, sigma, rho, beta), ...
                'Jacobian',                     @(t, y) otp.lorenz63.jac(t, y, sigma, rho, beta), ...
                'JacobianVectorProduct',        @(t, y, v) otp.lorenz63.jvp(t, y, v, sigma, rho, beta), ...
                'JacobianAdjointVectorProduct', @(t, y, v) otp.lorenz63.javp(t, y, v, sigma, rho, beta), ...
                'PartialDerivativeParameters',  @(t, y) otp.lorenz63.pdparams(t, y, sigma, rho, beta), ...
                'HessianVectorProduct',         @(t, y, u, v) otp.lorenz63.hvp(t, y, u, v, sigma, rho, beta), ...
                'HessianAdjointVectorProduct',  @(t, y, u, v) otp.lorenz63.havp(t, y, u, v, sigma, rho, beta));
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
            sol = internalSolve@otp.Problem(obj, 'Method', @ode45, varargin{:});
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
