classdef Geostationary2D < otp.circularrestricted3body.CR3BPProblem
    % This preset builds a geostationary earth orbit in CR3BP based on
    % the equations derived in :cite:p:`She20`.

       methods
           function obj = Geostationary2D(varargin)
            % Create the Geostationary2D CR3BP problem object.
            %

            equatorialRadius = 6378;
            earthMoonDist = 385000;
            orbitalradius = 35786;

            % set the relative distance from earth to the moon
            delta = (equatorialRadius + orbitalradius)/earthMoonDist;
            
            mE = otp.utils.PhysicalConstants.EarthMass;
            mL = otp.utils.PhysicalConstants.MoonMass;
            G  = otp.utils.PhysicalConstants.GravitationalConstant;

            % derive mu
            muE = G*mE;
            muL = G*mL;
            mu = muL/(muE + muL);

            % set initial distance to Earth
            x0 = -mu + delta;

            % derive the initial velocity 
            y0 = -sqrt((1 - mu)/delta);

            % set the orbital period
            period = 1.990657112517908e-01;

            y0    = [x0; 0; 0; y0];
            tspan = [0, period];
            params = otp.circularrestricted3body.CR3BPParameters(...
                'Mu', mu, ...
                'SoftFactor', 1e-3, ...
                varargin{:});
            obj = obj@otp.circularrestricted3body.CR3BPProblem(tspan, y0, params);            
        end
    end
end
