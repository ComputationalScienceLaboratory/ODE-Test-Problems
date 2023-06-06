classdef SunEarth < otp.nbody.NBodyProblem
    methods
        function obj = SunEarth()
            params = otp.nbody.NBodyParameters;
            params.SpatialDim = otp.utils.PhysicalConstants.TwoD;
            params.Masses = [otp.utils.PhysicalConstants.SunMass; otp.utils.PhysicalConstants.EarthMass] / 1e24;
            params.GravitationalConstant = otp.utils.PhysicalConstants.GravitationalConstant * 1e6 * otp.utils.PhysicalConstants.SecondsPerDay^2;
            params.SofteningLength = 0;
            
            positions = [0; 0; otp.utils.PhysicalConstants.EarthSunDistance / 1e6; 0];
            velocities = [0; 0; 0; otp.utils.PhysicalConstants.EarthVelocity * otp.utils.PhysicalConstants.SecondsPerDay / 1e6];
            y0 = [positions; velocities];
            
            tspan = [0, otp.utils.PhysicalConstants.DaysPerYear];
            
            obj = obj@otp.nbody.NBodyProblem(tspan, y0, params);
        end
    end
end
