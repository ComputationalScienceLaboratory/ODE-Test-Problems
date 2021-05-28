classdef Canonical < otp.campbellmooredae.CampbellMooreDAEProblem
    methods
        function obj = Canonical()
            tspan = [0.0, 10*pi];
            
            
            params.r = 10;
            params.rho = 5;
            
            y0 = [15, 0, 0, 0, 0.039524144269346, -0.417592117550000, 0.042213548262602, -0.034980779193327, 0, 0]';
            
            obj = obj@otp.campbellmooredae.CampbellMooreDAEProblem(tspan, y0, params);
        end
    end
end
