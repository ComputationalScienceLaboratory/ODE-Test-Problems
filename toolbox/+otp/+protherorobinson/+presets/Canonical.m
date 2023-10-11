classdef Canonical < otp.protherorobinson.ProtheroRobinsonProblem
    % The Prothero–Robinson configuration from :cite:p:`PR74` (p. 159) based on :cite:p:`SLH70` (p. 272). It uses time
    % span $t \in [0, 15]$, initial condition $y(0) = \phi(0)$, and parameters
    %
    % $$
    % \lambda &= -200, \\
    % \phi(t) &= 10 - (10 + t) e^{-t}.
    % $$

    methods
        function obj = Canonical(varargin)
            % Create the Canonical Prothero–Robinson problem object.
            %
            % Parameters
            % ----------
            % varargin
            %    A variable number of name-value pairs. The accepted names are
            %
            %    - ``Lambda`` – The stiffness parameter and eigenvalue of the Jacobian $\lambda$.
            %    - ``Phi`` – The exact solution.
            %    - ``DPhi`` – The time derivative of $\phi(t)$.
            %
            % Returns
            % -------
            % obj : ProtheroRobinsonProblem
            %    The constructed problem
            
            params = otp.protherorobinson.ProtheroRobinsonParameters('Lambda', -200, ...
                'Phi', @(t) 10 - (10 + t) .* exp(-t), 'DPhi', @(t) (9 + t) .* exp(-t), varargin{:});
            tspan = [0, 15];
            y0 = params.Phi(tspan(1));
            
            obj = obj@otp.protherorobinson.ProtheroRobinsonProblem(tspan, y0, params);
        end
        
    end
end