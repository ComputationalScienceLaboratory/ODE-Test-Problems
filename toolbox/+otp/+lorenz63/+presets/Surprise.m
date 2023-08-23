classdef Surprise < otp.lorenz63.Lorenz63Problem
    % Lorenz '63 preset 'surprise' from :cite:p:`Str18` which uses time span $t \in [0, 60]$, 
    % $\sigma = 10$, $\rho = 100$, $\beta = 8/3$, and intial conditions $y_0 = [2, 1, 1]^T$.

    methods
        function obj = Surprise

            sigma = 10;
            rho   = 100;
            beta  = 8/3;

            params = otp.lorenz63.Lorenz63Parameters;
            params.Sigma = sigma;
            params.Rho   = rho;
            params.Beta  = beta;
            
            % Hand-picked initial conditions with the canonical timespan
            
            y0    = [2; 1; 1];
            tspan = [0 60];
            
            obj = obj@otp.lorenz63.Lorenz63Problem(tspan, y0, params);
        end
    end
end
