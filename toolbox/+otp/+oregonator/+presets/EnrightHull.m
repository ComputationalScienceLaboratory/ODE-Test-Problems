classdef EnrightHull < otp.oregonator.OregonatorProblem
    % The Oregonator configuration used in problem CHM 9 of :cite:p:`EH76`. It uses time span $t ∈ [0, 300]$, initial
    % condition $y_0 = [4, 1.1, 4]^T$, and parameters
    %
    % $$
    % f &= 1, \\
    % q &= 8.375 \times 10^{-6}, \\
    % s &= 77.27, \\
    % w &= 0.1610.
    % $$

    methods
        function obj = EnrightHull
            % Create the Enright–Hull Oregonator problem object.

            tspan = [0, 300];
            y0 = [4; 1.1; 4];
            params = otp.oregonator.OregonatorParameters('F', 1, 'Q', 8.375e-6, 'S', 77.27, 'W', 0.1610);
            
            obj = obj@otp.oregonator.OregonatorProblem(tspan, y0, params);
        end
    end
end