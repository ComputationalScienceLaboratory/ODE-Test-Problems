classdef Canonical < otp.oregonator.OregonatorProblem
    % The Oregonator configuration used in :cite:p:`HW96` (p. 144) called OREGO. It uses time span $t ∈ [0, 360]$,
    % initial condition $y_0 = [1, 2, 3]^T$, and parameters
    %
    % $$
    % f &= 1, \\
    % q &= 8.375 \times 10^{-6}, \\
    % s &= 77.27, \\
    % w &= 0.1610.
    % $$

    methods
        function obj = Canonical(varargin)
            % Create the canonical Oregonator problem object.
            %
            % Parameters
            % ----------
            % varargin
            %    A variable number of name-value pairs. The accepted names are
            %
            %    - ``f`` – Value of $f$.
            %    - ``q`` – Value of $q$.
            %    - ``s`` – Value of $s$.
            %    - ``w`` – Value of $w$.

            tspan = [0, 360];
            y0 = [1; 2; 3];
            params = otp.oregonator.OregonatorParameters('F', 1, 'Q', 8.375e-6, 'S', 77.27, 'W', 0.1610, varargin{:});
            obj = obj@otp.oregonator.OregonatorProblem(tspan, y0, params);
        end
    end
end