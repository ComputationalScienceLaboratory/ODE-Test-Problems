classdef LimitCycle < otp.lorenz63.Lorenz63Problem
    % Lorenz '63 preset limit cycle, a non-chaotic preset, from :cite:p:`Str18` 
    % which uses time span $t \in [0, 60]$, $\sigma = 10$, $\rho = 350$, 
    % $\beta = 8/3$, and intial conditions $y_0 = [0, 1, 0]^T$.
    
    methods
        function obj = LimitCycle
            params = otp.lorenz63.Lorenz63Parameters('Sigma', 10, 'Rho', 350, 'Beta', 8/3);
            
            % We use Lorenz's initial conditions and timespan as Strogatz
            % does not specify those in his book.
            
            y0    = [0; 1; 0];
            tspan = [0 60];
            
            obj = obj@otp.lorenz63.Lorenz63Problem(tspan, y0, params);            
        end
    end
end
