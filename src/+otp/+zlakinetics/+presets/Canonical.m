classdef Canonical < otp.zlakinetics.ZlaKineticsProblem
    methods
        function obj = Canonical
            tspan = [0, 180];
            
            params.k = [18.7, 0.58, 0.09, 0.42];
            params.K = 34.4;
            params.klA = 3.3;
            params.Ks = 115.83;
            params.pCO2 = 0.9;
            params.H = 737;
            
            y0 = [0.444; 0.00123; 0; 0.007; 0; 0];
            y0(end) = params.Ks * y0(1) * y0(4);
            
            obj = obj@otp.zlakinetics.ZlaKineticsProblem(tspan, y0, params);
        end
    end
end
