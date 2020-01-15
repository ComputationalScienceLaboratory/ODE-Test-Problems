classdef Canonical < otp.trigonometricdae.TrigonometricDAEProblem
    methods
        function obj = Canonical(epsilon)
            if nargin < 1
                epsilon = 0;
            end
            tspan = [0.5, 2];
            y0 = [sinh(0.5); tanh(0.5)];
            params.epsilon = epsilon;
            obj = obj@otp.trigonometricdae.TrigonometricDAEProblem(tspan, y0, params);            
        end
    end
end

