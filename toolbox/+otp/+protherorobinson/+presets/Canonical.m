classdef Canonical < otp.protherorobinson.ProtheroRobinsonProblem
    % The Prothero–Robinson configuration from :cite:p:`PR74` (p. 159) based on :cite:p:`SLH70` (p. 272). It uses
    %
    % $$
    % t &\in [0, 15] \\
    % y(0) &= \phi(0) \\
    % \lambda &= -200 \\
    % \phi(t) &= 10 - (10 + t) e^{-t}
    % $$

    methods
        function obj = Canonical(lambda, phi, dphi)
            % Create the Canonical Prothero–Robinson problem object.
            %
            % Parameters
            % ----------
            % 
            % lambda : numeric(1, 1), default=-200
            %    The stiffness parameter and eigenvalue of the Jacobian $\lambda$.
            % phi : function_handle, default=@(t)10-(10+t).*exp(-t)
            %    The exact solution.
            % dphi : function_handle, default=@(t)(9+t).*exp(-t)
            %    The time derivative of $\phi(t)$.
            %
            % Returns
            % -------
            % obj : ProtheroRobinsonProblem
            %    The constructed problem
            if nargin < 1 || isempty(lambda)
                lambda = -200;
            end
            if nargin < 2 || isempty(phi)
                phi = @(t) 10 - (10 + t) .* exp(-t);
                dphi = @(t) (9 + t) .* exp(-t);
            end
            
            params = otp.protherorobinson.ProtheroRobinsonParameters;
            params.Lambda = lambda;
            params.Phi = phi;
            params.DPhi = dphi;
            tspan = [0, 15];
            y0 = phi(tspan(1));
            
            obj = obj@otp.protherorobinson.ProtheroRobinsonProblem(tspan, y0, params);
        end
        
    end
end