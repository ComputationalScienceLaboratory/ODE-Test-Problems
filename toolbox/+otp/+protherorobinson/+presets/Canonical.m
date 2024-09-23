classdef Canonical < otp.protherorobinson.ProtheroRobinsonProblem
    % The Prothero–Robinson configuration from :cite:p:`PR74` (p. 159) based on :cite:p:`SLH70` (p. 272). It uses time
    % span $t ∈ [0, 15]$, initial condition $y(0) = φ(0)$, and parameters
    %
    % $$
    % λ &= -200, \\
    % φ(t) &= 10 - (10 + t) e^{-t}.
    % $$

    methods
        function obj = Canonical(varargin)
            % Create the canonical Prothero–Robinson problem object.
            %
            % Parameters
            % ----------
            % varargin
            %    A variable number of name-value pairs. The accepted names are
            %
            %    - ``Lambda`` – The stiffness parameter and eigenvalue of the Jacobian $λ$.
            %    - ``Phi`` – The exact solution.
            %    - ``DPhi`` – The time derivative of $φ(t)$.
            
            params = otp.protherorobinson.ProtheroRobinsonParameters('Lambda', -200, ...
                'Phi', @(t) 10 - (10 + t) .* exp(-t), 'DPhi', @(t) (9 + t) .* exp(-t), varargin{:});
            tspan = [0, 15];
            y0 = params.Phi(tspan(1));
            obj = obj@otp.protherorobinson.ProtheroRobinsonProblem(tspan, y0, params);
        end
    end
end