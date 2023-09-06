classdef Canonical < otp.ascherlineardae.AscherLinearDAEProblem
    % The original problem defined by Uri Ascher in :cite:p:`Asc89` with 
    % $\beta = 0.5$
    % 
    methods
        function obj = Canonical(beta)
            tspan = [0.0; 1];
            
            if nargin < 1
                beta = 0.5;
            end
            
            params = otp.ascherlineardae.AscherLinearDAEParameters;
            params.Beta = beta;
            
            y0 = [1; beta];
            
            obj = obj@otp.ascherlineardae.AscherLinearDAEProblem(tspan, y0, params);
        end
    end
end
