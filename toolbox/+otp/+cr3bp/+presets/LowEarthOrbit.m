classdef LowEarthOrbit < otp.cr3bp.CR3BPProblem
    % A trivial preset with a stable oscillating orbit around a lagrange point.
       methods
           function obj = LowEarthOrbit(varargin)
            % Create the Canonical CR3BP problem object.


            equatorialRadius = 6378;
            earthMoonDist = 385000;

            delta = equatorialRadius/earthMoonDist;
            
            mE = otp.utils.PhysicalConstants.EarthMass;
            mL = otp.utils.PhysicalConstants.MoonMass;
            G  = otp.utils.PhysicalConstants.GravitationalConstant;

            % derive mu
            muE = G*mE;
            muL = G*mL;
            mu = muL/(muE + muL);

            x0 = -mu + delta;
            y0 = -7.717617954315369e+00;

            y0    = [x0; 0; 0; 0; y0; 0];
            tspan = [0, 1.348715080895850e-01];
            params = otp.cr3bp.CR3BPParameters('Mu', mu, 'SoftFactor', 1e-3, varargin{:});
            obj = obj@otp.cr3bp.CR3BPProblem(tspan, y0, params);            
        end
    end
end
