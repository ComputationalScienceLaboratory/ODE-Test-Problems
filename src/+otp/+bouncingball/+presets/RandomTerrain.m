classdef RandomTerrain < otp.bouncingball.BouncingBallProblem
    % [Name]
    %  Random Terrain
    
    % [Description]
    %  Creates random terrain through the composition of sinusoidal
    %  functions.
    %
    % [NoVars]
    %  4
    %
    methods
        function obj = RandomTerrain
            params.g = otp.utils.PhysicalConstants.EarthGravity;
            
            n = 32;
            
            magnitudes = 0.2 * randn(n, 1);
            periods = randn(n, 1);
            phases = randn(n, 1);
            
            params.ground  = @(x) 0.05*x^2 + sum(magnitudes .* cos(periods * x + phases));
            params.groundSlope = @(x) 0.1*x - sum(magnitudes .* periods .* sin(periods * x + phases));
            
            y0 = [0; 5; 5; 0];
            tspan = [0; 50];
            
            obj = obj@otp.bouncingball.BouncingBallProblem(tspan, y0, params);
            
        end
    end
end
