classdef Canonical < otp.ascherlineardae.AscherLinearDAEProblem
    methods
        function obj = Canonical(beta)
            tspan = [0.0; 1];
            
            if nargin < 1
                beta = 0.5;
            end
            
            params.beta = beta;
            
            y0 = [1; beta];
            
            obj = obj@otp.ascherlineardae.AscherLinearDAEProblem(tspan, y0, params);
        end
    end
end
