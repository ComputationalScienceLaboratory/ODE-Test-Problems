classdef Canonical < otp.bouncingball.BouncingBallProblem
    %CANONICAL The ball has no horizontal velocity, and bounces on a perfectly flat surface.

    methods
        function obj = Canonical(varargin)
            y0 = [0; 1; 0; 0];
            tspan = [0 10];
            params = otp.bouncingball.BouncingBallParameters( ...
                'Gravity', otp.utils.PhysicalConstants.EarthGravity, ...
                'Ground', @(x) 0, ...
                'GroundSlope', @(x) 0, ...
                varargin{:});
            
            obj = obj@otp.bouncingball.BouncingBallProblem(tspan, y0, params);
        end
    end
end
