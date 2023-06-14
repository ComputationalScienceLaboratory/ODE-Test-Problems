classdef RandomTerrain < otp.bouncingball.BouncingBallProblem
    %RANDOMTERRAIN Creates random terrain through the composition of sinusoidal functions.
    %
    methods
        function obj = RandomTerrain
            params.Gravity = otp.utils.PhysicalConstants.EarthGravity;
            
            n = 32;
            
            magnitudes = 0.2 * randn(n, 1);
            periods = randn(n, 1);
            phases = randn(n, 1);
            
            params.Ground      = @(x) 0.05*x^2 + sum(magnitudes .* cos(periods * x + phases));
            params.GroundSlope = @(x) 0.1*x - sum(magnitudes .* periods .* sin(periods * x + phases));
            
            y0 = [0; 5; 5; 0];
            tspan = [0; 50];
            
            obj = obj@otp.bouncingball.BouncingBallProblem(tspan, y0, params);
            
        end
    end
end
