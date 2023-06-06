classdef Parabola < otp.bouncingball.BouncingBallProblem
    %PARABOLA The ball bounces on a parabola, starting slightly off-center as to create
    %  an interesting trajectory.
    %
    methods
        function obj = Parabola
            params.Gravity     = otp.utils.PhysicalConstants.EarthGravity;
            params.Ground      = @(x) x^2;
            params.GroundSlope = @(x) 2*x;
            
            y0 = [0; 1; 1; 0];
            tspan = [0, 10];            
            obj = obj@otp.bouncingball.BouncingBallProblem(tspan, y0, params);
        end
    end
end
