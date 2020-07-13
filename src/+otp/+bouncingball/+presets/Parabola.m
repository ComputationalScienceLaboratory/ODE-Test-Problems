classdef Parabola < otp.bouncingball.BouncingBallProblem
    % [Name]
    %  Parabola
    %
    % [Description]
    %  The ball bounces on a parabola, starting slightly off-center as to create
    %  an interesting trajectory.
    %
    % [NoVars]
    %  4
    %
    % [Properties]
    %
    % [Usage]
    %
    methods
        function obj = Parabola
            params.g = otp.utils.PhysicalConstants.EarthGravity;
            params.groundFunction  = @(x) x^2;
            params.dgroundFunction = @(x) 2*x;
            
            y0 = [0; 1; 1; 0];
            tspan = [0, 50];            
            obj = obj@otp.bouncingball.BouncingBallProblem(tspan, y0, params);
        end
    end
end
