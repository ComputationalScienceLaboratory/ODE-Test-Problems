classdef RandomTerrain < otp.bouncingball.BouncingBallProblem
    %RANDOMTERRAIN Creates random terrain through the composition of sinusoidal functions.
    %
    methods
        function obj = RandomTerrain
            y0 = [0; 5; 5; 0];
            tspan = [0; 50];

            n = 32;
            magnitudes = 0.2 * randn(n, 1);
            periods = randn(n, 1);
            phases = randn(n, 1);

            params = otp.bouncingball.BouncingBallParameters( ...
                'Gravity', otp.utils.PhysicalConstants.EarthGravity, ...
                'Ground', @(x) 0.05*x^2 + sum(magnitudes .* cos(periods * x + phases)), ...
                'GroundSlope', @(x) 0.1*x - sum(magnitudes .* periods .* sin(periods * x + phases)));

            obj = obj@otp.bouncingball.BouncingBallProblem(tspan, y0, params);
        end
    end
end
