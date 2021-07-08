classdef Canonical < otp.bouncingball.BouncingBallProblem
    % [Name]
    %  Flat Terrain
    %
    % [Description]
    %  The ball has no horizontal velocity, and bounces on a perfectly flat surface.
    %
    % [NoVars]
    %  4
    %
    % [Properties]
    %
    % [Usage]
    %
    methods
        function obj = Canonical
            params.g = otp.utils.PhysicalConstants.EarthGravity;
            params.ground= @(x) 0;
            params.groundSlope= @(x) 0;
            
            y0 = [0; 1; 0; 0];
            tspan = [0 10];
            
            obj = obj@otp.bouncingball.BouncingBallProblem(tspan, y0, params);
            
        end
    end
end
