classdef GottwaldWanner < otp.oregonator.OregonatorProblem
    % The Oregonator configuration from :cite:p:`GW82` which uses time span $t \in [0, 302.85805]$, initial condition
    % $y_0 = [4, 1.331391, 2.852348]^T$, and parameters
    %
    % $$
    % f &= 1, \\
    % q &= 8.375 \cdot 10^{-6}, \\
    % s &= 77.27, \\
    % w &= 0.1610.
    % $$
    %
    % The initial condition lies on a stable limit cycle, and the time span is chosen to be one period.

    methods
        function obj = GottwaldWanner
            % Create the GottwaldWanner problem object.
            %
            % Parameters
            % ----------
            %
            % Returns
            % -------
            % obj : GottwaldWanner
            %    The constructed problem.

            tspan = [0, 302.85805];
            y0 = [4; 1.331391; 2.852348];
            params = otp.oregonator.OregonatorParameters;
            params.F = 1;
            params.Q = 8.375e-6;
            params.S = 77.27;
            params.W = 0.1610;
            
            obj = obj@otp.oregonator.OregonatorProblem(tspan, y0, params);
        end
    end
end