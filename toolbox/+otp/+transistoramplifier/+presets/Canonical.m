classdef Canonical < otp.transistoramplifier.TransistorAmplifierProblem
    methods
        function obj = Canonical
            tspan = [0.0, 0.2];

            params = otp.transistoramplifier.TransistorAmplifierParameters;
            params.C = (1:5)*1e-6;
            params.R = [1000, 9000*ones(1,9)];
            params.Ub = 6;
            params.UF = 0.026;
            params.Alpha = 0.99;
            params.Beta = 1e-6;

            y02 = params.Ub/(params.R(3)/params.R(2) +1);
            y05 = params.Ub/(params.R(7)/params.R(6) +1);
            y0 = [0; y02; y02; params.Ub; y05; y05; params.Ub; 0];

            obj = obj@otp.transistoramplifier.TransistorAmplifierProblem(tspan, y0, params);            
        end
    end
end
