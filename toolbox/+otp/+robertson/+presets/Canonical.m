classdef Canonical < otp.robertson.RobertsonProblem
    % The original configuration :cite:p:`Rob66` with $t ∈ [0, 40]$, $y_0 = [1, 0, 0]^T$, and parameters
    %
    % $$
    % k_1 &= 4 \times 10^{-2}, \\
    % k_2 &= 3 \times 10^7, \\
    % k_3 &= 10^4.
    % $$

    methods
        function obj = Canonical(varargin)
            % Create the canonical Robertson problem object.
            %
            % Parameters
            % ----------
            % varargin
            %    A variable number of name-value pairs. The accepted names are
            %
            %    - ``K1`` – Value of $k_1$.
            %    - ``K2`` – Value of $k_2$.
            %    - ``K3`` – Value of $k_3$.
            
            y0 = [1; 0; 0];
            tspan = [0, 40];
            params = otp.robertson.RobertsonParameters('K1', 0.04, 'K2', 3e7, 'K3', 1e4, varargin{:});
            obj = obj@otp.robertson.RobertsonProblem(tspan, y0, params);
        end
    end
end
