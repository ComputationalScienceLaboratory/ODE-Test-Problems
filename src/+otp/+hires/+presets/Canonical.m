classdef Canonical < otp.hires.HIRESProblem
    methods
        function obj = Canonical
            tspan = [0, 321.8122];
            y0 = [1; 0; 0; 0; 0; 0; 0; 0.0057];
            params = otp.hires.HIRESParameters;
            
            obj = obj@otp.hires.HIRESProblem(tspan, y0, params);
        end
    end
end