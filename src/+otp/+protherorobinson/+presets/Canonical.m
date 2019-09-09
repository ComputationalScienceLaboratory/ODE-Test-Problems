classdef Canonical < otp.protherorobinson.ProtheroRobinsonProblem
    methods
        function obj = Canonical(lambda, phi, dphi)
            if nargin < 1
                lambda = -1;
            end
            if nargin < 2
                phi = @sin;
                dphi = @cos;
            end
            
            params.lambda = lambda;
            params.phi = phi;
            params.dphi = dphi;
            tspan = [0, 10];
            y0 = phi(tspan(1));
            
            obj = obj@otp.protherorobinson.ProtheroRobinsonProblem(tspan, y0, params);
        end
        
    end
end