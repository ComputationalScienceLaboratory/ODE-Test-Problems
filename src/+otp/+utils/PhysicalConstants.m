classdef PhysicalConstants

    properties (Constant)
        GravitationalConstant = 6.67408e-11; % m^3 / (kg s^2)
        
        SunMass = 1.98855e30; % kg
        EarthMass = 5.9722e24; % kg
        MoonMass = 7.34767309e22; % kg
        
        EarthSunDistance = 1.496e11; % m
        EarthMoonDistance = 3.844e8; % m
        
        EarthVelocity = 2.9785e4; % m / s
        MoonVelocity = 1.022e3; % m / s
        
        SecondsPerDay = 86400; % s
        DaysPerYear = 365.25; % d
        
        EarthGravity = 9.80665;
    end
    
end