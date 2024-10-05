classdef ROBER < otp.robertson.RobertsonProblem
    % The Robertson configuration from :cite:p:`HW96` (p. 144). This differs from
    % :class:`otp.robertson.presets.Canonical` only in the time span which is extended to $[0, 10^{11}]$. This presents
    % a challenge for numerical integrators to preserve solution positivity.

    methods
        function obj = ROBER
            % Create the ROBER Robertson problem object.
            
            y0 = [1; 0; 0];
            tspan = [0, 1e11];
            params = otp.robertson.RobertsonParameters('K1', 0.04, 'K2', 3e7, 'K3', 1e4);
            obj = obj@otp.robertson.RobertsonProblem(tspan, y0, params);
        end
    end
end
