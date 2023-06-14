classdef Canonical < otp.lorenz63.Lorenz63Problem
    % This is the original problem presented in the literature.
    % The initial condition is purposefully outside of the attractor, but converges to it quite quickly.
    % 
    % References:
    %      Lorenz, E. N. (1963). Deterministic nonperiodic flow. Journal of atmospheric sciences, 20(2), 130-141.
    %
    % See also :class:`+otp.+lorenz63.Lorenz63Problem`

    methods
        function obj = Canonical(sigma, rho, beta)
            % Construct a Lorenz '63 problem
            %
            %   problem = Canonical(sigma, rho, beta) defines the Lorenz '63
            %   problem with corresponding parameters
            %
            %   problem = Canonical() sets the default values of the parameters
            %   to Sigma = 10, Rho = 28, and Beta = 8/3. The arguments can
            %   be left empty or ignored to use these defaults.
    
            if nargin < 1 || isempty(sigma)
                sigma = 10;
            end
            
            if nargin < 2 || isempty(rho)
                rho = 28;
            end
            
            if nargin < 3 || isempty(beta)
                beta = 8/3;
            end

            params = otp.lorenz63.Lorenz63Parameters;
            
            params.Sigma = sigma;
            params.Rho   = rho;
            params.Beta  = beta;
            
            y0    = [0; 1; 0];
            tspan = [0 60];
            
            obj = obj@otp.lorenz63.Lorenz63Problem(tspan, y0, params);            
        end
    end
end