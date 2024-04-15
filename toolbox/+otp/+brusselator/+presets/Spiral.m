classdef Spiral < otp.brusselator.BrusselatorProblem
    % Brusselator preset with a stable spiral phase plot. It uses time span $t ∈ [0, 30]$, initial conditions
    % $y_0 = [1, 1]^T$, and parameters $A = 1$ and $B = 1.7$.

    methods
        function obj = Spiral()
            % Create the spiral Brusselator problem object.

            y0 = [1; 1];
            tspan = [0, 30];
            params = otp.brusselator.BrusselatorParameters('A', 1, 'B', 1.7);            
            obj = obj@otp.brusselator.BrusselatorProblem(tspan, y0, params);
        end
    end
end
