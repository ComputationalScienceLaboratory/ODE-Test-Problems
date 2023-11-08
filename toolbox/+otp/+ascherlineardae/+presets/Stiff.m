classdef Stiff < otp.ascherlineardae.AscherLinearDAEProblem
    % The Stiff example from :cite:p:`Asc89`. A variant of the Ascher linear DAE problem which uses time span 
    % $t ∈ [0, 1]$ and $β = 100$ with the initial condition $[y_0, z_0]^T = [1, 100]^T$.

    methods
        function obj = Stiff()
            % Create the stiff Ascher Linear DAE problem object.

            params = otp.ascherlineardae.AscherLinearDAEParameters('Beta', 100);
            y0 = [1; params.Beta];
            tspan = [0.0; 1.0];
            obj = obj@otp.ascherlineardae.AscherLinearDAEProblem(tspan, y0, params);
        end
    end
end
