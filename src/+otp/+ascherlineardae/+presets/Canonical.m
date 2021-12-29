classdef Canonical < otp.ascherlineardae.AscherLinearDAEProblem
    %CANONICAL The problem formulation of the linear DAE from the literature
    %
    % See
    %    Ascher, Uri. "On symmetric schemes and differential-algebraic equations."
    %    SIAM journal on scientific and statistical computing 10.5 (1989): 937-949.
    
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
