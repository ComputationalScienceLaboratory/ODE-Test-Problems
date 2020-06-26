classdef Canonical < otp.zlakinetics.ZLAKineticsProblem
    methods
        function obj = Canonical
            tspan = [0.0, 180.0];
            
            params.k = [18.7, 0.58, 0.09, 0.42];
            params.K = 34.4;
            params.KlA = 3.3;
            params.pCO2 = 0.9;
            params.H = 737.0;
            params.Ks = 115.83;

            y0 = [0.444, 0.00123, 0, 0.007, 0, params.Ks*0.444*0.007]';

            obj = obj@otp.zlakinetics.ZLAKineticsProblem(tspan, y0, params);            
        end
    end
end
