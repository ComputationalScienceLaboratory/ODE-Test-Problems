classdef Stiff < otp.ascherlineardae.AscherLinearDAEProblem
    % The Stiff example from :cite:p:`Asc89`. A variant of the 
    % Ascher linear DAE problem
    % which uses timespan $t \in [0, 1]$  and  $\beta = 100 $ with the initial condition $[y_0, z_0]^T = [1, 100]^T $.
    % 
    methods
        function obj = Stiff
            % Create the stiff example of the Ascher linear DAE problem object.
            params      = otp.ascherlineardae.AscherLinearDAEParameters;
            params.Beta = 100;
            
            y0    = [1; params.Beta];
            tspan = [0.0; 1.0];
            
            obj = obj@otp.ascherlineardae.AscherLinearDAEProblem(tspan, y0, params);
        end
    end
end
