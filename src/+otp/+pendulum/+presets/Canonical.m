classdef Canonical < otp.pendulum.PendulumProblem
    methods
        function obj = Canonical(numBobs)
            if nargin < 1
                numBobs = 1;
            end
            
            params.g = otp.utils.PhysicalConstants.EarthGravity;
            
            o = ones(numBobs, 1);
            params.lengths = o;
            params.masses = o;
            
            y0 = [pi/2 * o; zeros(numBobs, 1)];
            tspan = [0, 10];
            
            obj = obj@otp.pendulum.PendulumProblem(tspan, y0, params);
        end
    end
end
