classdef SunEarthMoon < otp.nbody.NBodyProblem
    methods
        function obj = SunEarthMoon()
            import otp.utils.PhysicalConstants
            
            params.spacialDim = 2;
            params.masses = [PhysicalConstants.SunMass; PhysicalConstants.EarthMass; PhysicalConstants.MoonMass] / 1e24;
            params.gravitationalConstant = PhysicalConstants.GravitationalConstant * 1e6 * PhysicalConstants.SecondsPerDay^2;
            params.softeningLength = 0;
            
            positions = [ ...
                0; 0; ...
                PhysicalConstants.EarthSunDistance; 0; ...
                PhysicalConstants.EarthSunDistance + PhysicalConstants.EarthMoonDistance; 0; ...
                ] / 1e6;
            velocities = [ ...
                0; 0; ...
                0; PhysicalConstants.EarthVelocity; ...
                0; PhysicalConstants.EarthVelocity + PhysicalConstants.MoonVelocity ...
                ] * PhysicalConstants.SecondsPerDay / 1e6;
            y0 = [positions; velocities];
            
            tspan = [0, PhysicalConstants.DaysPerYear];
            
            obj = obj@otp.nbody.NBodyProblem(tspan, y0, params);
        end
    end
end
