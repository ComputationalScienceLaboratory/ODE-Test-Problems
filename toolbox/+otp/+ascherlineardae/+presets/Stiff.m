classdef Stiff < otp.ascherlineardae.AscherLinearDAEProblem
    % The Stiff example from :cite:p:`Asc89` (sec. 2. A variant of the 
    % Ascher linear DAE problem
    % which uses timespan $t \in [0, 1]$  and  $\beta = 100 $.
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
