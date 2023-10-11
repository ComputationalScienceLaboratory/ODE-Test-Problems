classdef Canonical < otp.robertson.RobertsonProblem
    % The original configuration :cite:p:`Rob67` with $t \in [0, 40]$, $y_0 = [1, 0, 0]^T$, and parameters
    %
    % $$
    % K_1 &= 4\times 10^{-2}, \\
    % K_2 &= 3\times 10^7, \\
    % K_3 &= 10^4.
    % $$
    methods
        function obj = Canonical(varargin)
            % Create the Canonical Robertson problem object.
            %
            % Parameters
            % ----------
            % varargin
            %    A variable number of name-value pairs. The accepted names are
            %
            %    - ``K1`` – Value of $K_1$.
            %    - ``K2`` – Value of $K_2$.
            %    - ``K3`` – Value of $K_3$.
            %
            % Returns
            % -------
            % obj : RobertsonProblem
            %    The constructed problem.
            
            y0 = [1; 0; 0];
            tspan = [0, 40];
            params = otp.robertson.RobertsonParameters('K1', 0.04, 'K2', 3e7, 'K3', 1e4, varargin{:});
            
            obj = obj@otp.robertson.RobertsonProblem(tspan, y0, params);
        end

    end
end
