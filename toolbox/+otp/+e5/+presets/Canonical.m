classdef Canonical < otp.e5.E5Problem
    methods
        function obj = Canonical
            params = otp.e5.E5Parameters;
            params.A = 7.89e-10;
            params.B = 1.1e7;
            params.C = 1.13e3;
            params.M = 1e6;
            
            y0 = [1.76e-3; 0; 0; 0];
            tspan = [0, 1e13];
            
            obj = obj@otp.e5.E5Problem(tspan, y0, params);
        end
    end
end
