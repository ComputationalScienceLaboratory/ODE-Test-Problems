classdef Canonical < otp.bouncingball.BouncingBallProblem
    %CANONICAL The ball has no horizontal velocity, and bounces on a perfectly flat surface.

    methods
        function obj = Canonical
            params = otp.bouncingball.BouncingBallParameters;
            params.Gravity     = otp.utils.PhysicalConstants.EarthGravity;
            params.Ground      = @(x) 0;
            params.GroundSlope = @(x) 0;
            
            y0 = [0; 1; 0; 0];
            tspan = [0 10];
            
            obj = obj@otp.bouncingball.BouncingBallProblem(tspan, y0, params);
            
        end
    end
end
