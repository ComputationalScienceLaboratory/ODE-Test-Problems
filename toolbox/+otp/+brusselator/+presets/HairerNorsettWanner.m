classdef HairerNorsettWanner < otp.brusselator.BrusselatorProblem
    % Brusselator preset proposed in :cite:p:`HNW93` (pg. 170) with $t \in [0, 20]$, $y_0 = [1.5, 3]^T$. The parameter
    % $A = 1$ and $B = 3$ yield a periodic solution.
    
    methods
        function obj = HairerNorsettWanner()
            % Create the Hairer­–Norsett–Wanner Brusselator problem object.
            
            y0 = [1.5; 3];
            tspan = [0, 20];
            params = otp.brusselator.BrusselatorParameters('A', 1, 'B', 3);            
            obj = obj@otp.brusselator.BrusselatorProblem(tspan, y0, params);
        end
    end
end
