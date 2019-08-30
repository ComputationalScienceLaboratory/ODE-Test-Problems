classdef Canonical < otp.protherorobinson.ProtheroRobinsonProblem
    methods
        function obj = Canonical(lambda, phi, dphi)
            if nargin < 1
                lambda = -1;
            end
            if nargin < 2
                phi = @sin;
            end
            if nargin < 3
                dphi = @cos;
            end
            
            params.lambda = lambda;
            params.phi = phi;
            params.dphi = dphi;
            
            obj = obj@otp.protherorobinson.ProtheroRobinsonProblem([0, 1], ones(size(lambda, 1), 1), params);
        end
        
    end
end