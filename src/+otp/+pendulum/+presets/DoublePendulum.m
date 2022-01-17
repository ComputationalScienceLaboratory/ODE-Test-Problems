classdef DoublePendulum < otp.pendulum.PendulumProblem
    methods
        function obj = DoublePendulum
            params = otp.pendulum.PendulumParameters;
            params.Gravity = otp.utils.PhysicalConstants.EarthGravity;
            params.Lengths = [1; 1];
            params.Masses  = [1; 1];
            
            y0 = [pi/3; 0; 0; 0];
            tspan = [0 10];
            
            obj = obj@otp.pendulum.PendulumProblem(tspan, y0, params);
        end
    end
end
