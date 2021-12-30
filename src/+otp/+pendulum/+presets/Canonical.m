classdef Canonical < otp.pendulum.PendulumProblem
    methods
        function obj = Canonical(numbobs)
            if nargin < 1 || isempty(numbobs)
                numbobs = 1;
            end
            

            params.Gravity = otp.utils.PhysicalConstants.EarthGravity;
            
            vecones = ones(numbobs, 1);
            params.Lengths = vecones;
            params.Masses  = vecones;
            
            y0 = [pi/2 * vecones; zeros(numbobs, 1)];
            tspan = [0, 10];
            
            obj = obj@otp.pendulum.PendulumProblem(tspan, y0, params);
        end
    end
end
