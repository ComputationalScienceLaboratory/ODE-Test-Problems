classdef Canonical < otp.oregonator.OregonatorProblem
    methods
        function obj = Canonical
            tspan = [0, 360];
            y0 = [1; 2; 3];
            params = otp.oregonator.OregonatorParameters;
            
            obj = obj@otp.oregonator.OregonatorProblem(tspan, y0, params);
        end
    end
end