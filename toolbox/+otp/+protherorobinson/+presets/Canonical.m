classdef Canonical < otp.protherorobinson.ProtheroRobinsonProblem
    methods
        function obj = Canonical(lambda, phi, dphi)
            if nargin < 1 || isempty(lambda)
                lambda = -1;
            end
            if nargin < 2 || isempty(phi)
                phi = @sin;
                dphi = @cos;
            end
            
            params = otp.protherorobinson.ProtheroRobinsonParameters;
            params.Lambda = lambda;
            params.Phi = phi;
            params.DPhi = dphi;
            tspan = [0, 10];
            y0 = phi(tspan(1));
            
            obj = obj@otp.protherorobinson.ProtheroRobinsonProblem(tspan, y0, params);
        end
        
    end
end