classdef SteadyState < otp.brusselator.BrusselatorProblem
    % Brusselator preset proposed in :cite:p:`LN71` (pg. 269) with $y_0 = [A, B/A]^T$, $A = 1$, and $B = 3$. No time
    % span is specified, so we take $t ∈ [0, 20]$. The solution is constant in time.

    methods
        function obj = SteadyState(varargin)
            % Create the steady state Brusselator problem object.
            %
            % Parameters
            % ----------
            % varargin
            %    A variable number of name-value pairs. The accepted names are
            %
            %    - ``A`` – Value of $A$.
            %    - ``B`` – Value of $B$.

            params = otp.brusselator.BrusselatorParameters('A', 1, 'B', 3, varargin{:}); 
            y0 = [params.A; params.B / params.A];
            tspan = [0, 20];           
            obj = obj@otp.brusselator.BrusselatorProblem(tspan, y0, params);
        end
    end
end
