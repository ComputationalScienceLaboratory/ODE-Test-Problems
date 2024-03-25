classdef Canonical < otp.brusselator.BrusselatorProblem
    % Brusselator preset proposed in :cite:p:`LN71` (pg. 269) with $y_0 = [0, 0]^T$, $A = 1$, and $B = 3$. No time span
    % is specified, so we take $t ∈ [0, 20]$. The solution asymptotically approaches a limit cycle.

    methods
        function obj = Canonical(varargin)
            % Create the Canonical Brusselator problem object.
            %
            % Parameters
            % ----------
            % varargin
            %    A variable number of name-value pairs. The accepted names are
            %
            %    - ``A`` – Value of $A$.
            %    - ``B`` – Value of $B$.
            
            y0 = [0; 0];
            tspan = [0, 20];
            params = otp.brusselator.BrusselatorParameters('A', 1, 'B', 3, varargin{:});         
            obj = obj@otp.brusselator.BrusselatorProblem(tspan, y0, params);
        end
    end
end
