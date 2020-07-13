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
            
            n = 1000;
            
            rng(6);
            
            genf  = @cos;
            dgenf = @sin;
            
            magnitudes = 1/32*randn(n, 1);
            periods    = 0.9*randn(n, 1);
            additions  = 0.25*randn(n, 1);
            
            groundFunction  = @(x) generateTerrain (x, genf,  magnitudes, periods, additions) + 0.01*x^2;
            dgroundFunction = @(x) dgenerateTerrain(x, dgenf, magnitudes, periods, additions) + 0.02*x;        
            
            params.groundFunction  = groundFunction;
            params.dgroundFunction = dgroundFunction;
            
            y0 = [0; 5.5; 5; 0];
            tspan = [0; 100];
            
            obj = obj@otp.bouncingball.BouncingBallProblem(tspan, y0, params);
            
        end
    end
end

function y = generateTerrain(x, genf, magnitudes, periods, additions)

y = 0;

for i = 1:numel(magnitudes)
    m = magnitudes(i);
    p = periods(i);
    a = additions(i);
    
    y = y + m*genf(p*x + a);
end

end

function y = dgenerateTerrain(x, dgenf, magnitudes, periods, additions)

y = 0;

for i = 1:numel(magnitudes)
    m = magnitudes(i);
    p = periods(i);
    a = additions(i);
    
    y = y - m*p*dgenf(p*x + a);
end

end
