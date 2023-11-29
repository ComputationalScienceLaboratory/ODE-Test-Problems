classdef Petzold < otp.ascherlineardae.AscherLinearDAEProblem
    % The Petzold DAE example :cite:p:`Pet86` as a special case of the Ascher linear DAE problem. This preset uses time
    % span $t ∈ [0, 1]$ and $β = 0 $ with the initial condition $[y_0, z_0]^T = [1, 0]^T$.

    methods
        function obj = Petzold()
            % Create the Petzold Ascher Linear DAE problem object.
            
            params = otp.ascherlineardae.AscherLinearDAEParameters('Beta', 0);
            y0 = [1; params.Beta];
            tspan = [0.0; 1.0];
            obj = obj@otp.ascherlineardae.AscherLinearDAEProblem(tspan, y0, params);
        end
    end
end
