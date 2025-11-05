classdef Surprise < otp.lorenz63.Lorenz63Problem
    % Lorenz '63 preset 'surprise' from :cite:p:`Str18` which uses time span $t ∈ [0, 60]$, $σ = 10$, $ρ = 100$,
    % $β = 8/3$, and initial conditions $y_0 = [2, 1, 1]^T$.

    methods
        function obj = Surprise
            % Create the surprise Lorenz '63 problem object.
            
            % Hand-picked initial conditions with the canonical time span
            y0    = [2; 1; 1];
            tspan = [0 60];
            params = otp.lorenz63.Lorenz63Parameters('Sigma', 10, 'Rho', 100, 'Beta', 8/3);
            obj = obj@otp.lorenz63.Lorenz63Problem(tspan, y0, params);
        end
    end
end
