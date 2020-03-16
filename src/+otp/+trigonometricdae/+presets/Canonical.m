classdef Canonical < otp.trigonometricdae.TrigonometricDAEProblem
    methods
        function obj = Canonical()
            tspan = [0.5, 2];
            y0 = [sinh(0.5); tanh(0.5)];
            obj = obj@otp.trigonometricdae.TrigonometricDAEProblem(tspan, y0, struct());            
        end
    end
end

