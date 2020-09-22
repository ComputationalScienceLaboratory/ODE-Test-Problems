classdef Canonical < otp.pendulum.PendulumProblem
    methods
        function obj = Canonical
            params.g = otp.utils.PhysicalConstants.EarthGravity;
            params.l = 1;
            
            y0 = [pi/3; 0];
            tspan = [0 10];
            
            obj = obj@otp.pendulum.PendulumProblem(tspan, y0, params);
        end
    end
end
