classdef SunEarth < otp.nbody.NBodyProblem
    methods
        function obj = SunEarth()
            import otp.utils.PhysicalConstants
            
            params.spatialDim = PhysicalConstants.TwoD;
            params.masses = [PhysicalConstants.SunMass; PhysicalConstants.EarthMass] / 1e24;
            params.gravitationalConstant = PhysicalConstants.GravitationalConstant * 1e6 * PhysicalConstants.SecondsPerDay^2;
            params.softeningLength = 0;
            
            positions = [0; 0; PhysicalConstants.EarthSunDistance / 1e6; 0];
            velocities = [0; 0; 0; PhysicalConstants.EarthVelocity * PhysicalConstants.SecondsPerDay / 1e6];
            y0 = [positions; velocities];
            
            tspan = [0, PhysicalConstants.DaysPerYear];
            
            obj = obj@otp.nbody.NBodyProblem(tspan, y0, params);
        end
    end
end
