classdef SunEarthMoon < otp.nbody.NBodyProblem
    methods
        function obj = SunEarthMoon()
            params = otp.nbody.NBodyParameters;
            params.SpatialDim = otp.utils.PhysicalConstants.TwoD;
            params.Masses = [otp.utils.PhysicalConstants.SunMass; otp.utils.PhysicalConstants.EarthMass; otp.utils.PhysicalConstants.MoonMass] / 1e24;
            params.GravitationalConstant = otp.utils.PhysicalConstants.GravitationalConstant * 1e6 * otp.utils.PhysicalConstants.SecondsPerDay^2;
            params.SofteningLength = 0;
            
            positions = [ ...
                0; 0; ...
                otp.utils.PhysicalConstants.EarthSunDistance; 0; ...
                otp.utils.PhysicalConstants.EarthSunDistance + otp.utils.PhysicalConstants.EarthMoonDistance; 0; ...
                ] / 1e6;
            velocities = [ ...
                0; 0; ...
                0; otp.utils.PhysicalConstants.EarthVelocity; ...
                0; otp.utils.PhysicalConstants.EarthVelocity + otp.utils.PhysicalConstants.MoonVelocity ...
                ] * otp.utils.PhysicalConstants.SecondsPerDay / 1e6;
            y0 = [positions; velocities];
            
            tspan = [0, otp.utils.PhysicalConstants.DaysPerYear];
            
            obj = obj@otp.nbody.NBodyProblem(tspan, y0, params);
        end
    end
end
