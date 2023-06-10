classdef Canonical < otp.trigonometricdae.TrigonometricDAEProblem
    methods
        function obj = Canonical()
            tspan = [0.5, 2];
            y0 = [sinh(0.5); tanh(0.5)];
            params = otp.trigonometricdae.TrigonometricDAEParameters;
            obj = obj@otp.trigonometricdae.TrigonometricDAEProblem(tspan, ...
                y0, params);            
        end
    end
end

