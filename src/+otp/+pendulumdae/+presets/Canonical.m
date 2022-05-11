classdef Canonical < otp.constrainedpendulum.ConstrainedPendulumProblem
    %CANONICAL The constrained pendulum problem
    %
    % See
    %    Ascher, Uri. "On symmetric schemes and differential-algebraic equations."
    %    SIAM journal on scientific and statistical computing 10.5 (1989): 937-949.
    
    methods
        function obj = Canonical
            tspan = [0; 10];
            
            params = otp.constrainedpendulum.ConstrainedPendulumParameters;
            params.Mass = 1;
            params.Length = 1;
            params.Gravity = otp.utils.PhysicalConstants.EarthGravity;
            
            y0 = [sqrt(2)/2; sqrt(2)/2; 0; 0];
            
            obj = obj@otp.constrainedpendulum.ConstrainedPendulumProblem(tspan, y0, params);
        end
    end
end
