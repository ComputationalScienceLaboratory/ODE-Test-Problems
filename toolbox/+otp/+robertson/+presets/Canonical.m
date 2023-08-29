classdef Canonical < otp.robertson.RobertsonProblem
    % The original configuration :cite:p:`Rob67` with $t \in [0, 40]$, $y_0 = [1, 0, 0]^T$, and parameters
    %
    % $$
    % K_1 &= 4\times 10^{-2}, \\
    % K_2 &= 3\times 10^7, \\
    % K_3 &= 10^4.
    % $$
    methods
        function obj = Canonical
            % Create the Canonical Robertson problem object.
            %
            % Parameters
            % ----------
            %
            % Returns
            % -------
            % obj : RobertsonProblem
            %    The constructed problem.
            
            params = otp.robertson.RobertsonParameters;
            params.K1 = 0.04;
            params.K2 = 3e7;
            params.K3 = 1e4;
            
            y0 = [1; 0; 0];
            tspan = [0, 40];
            
            obj = obj@otp.robertson.RobertsonProblem(tspan, y0, params);
        end

    end
end
