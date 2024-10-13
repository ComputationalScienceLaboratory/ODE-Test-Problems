classdef Canonical < otp.hires.HIRESProblem
    methods
        function obj = Canonical(varargin)
            tspan = [0, 321.8122];
            y0 = [1; 0; 0; 0; 0; 0; 0; 0.0057];
            params = otp.hires.HIRESParameters('K1', 1.71, 'K2', 0.43, 'K3', 8.32, 'K4', 0.69, 'K5', 0.035, ...
                'K6', 8.32, 'KPlus', 280, 'KMinus', 0.69, 'KStar', 0.69, 'OKS', 0.0007, varargin{:});
            obj = obj@otp.hires.HIRESProblem(tspan, y0, params);
        end
    end
end