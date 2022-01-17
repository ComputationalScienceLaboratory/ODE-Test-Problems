classdef Canonical < otp.pendulum.PendulumProblem
    methods
        function obj = Canonical(numBobs)
            if nargin < 1 || isempty(numBobs)
                numBobs = 1;
            end
            
            params.Gravity = otp.utils.PhysicalConstants.EarthGravity;
            
            vecOnes = ones(numBobs, 1);
            params.Lengths = vecOnes;
            params.Masses  = vecOnes;
            
            y0 = [pi/2*vecOnes; zeros(numBobs, 1)];
            tspan = [0, 10];
            
            obj = obj@otp.pendulum.PendulumProblem(tspan, y0, params);
        end
    end
end
