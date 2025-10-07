classdef CircularEarthOrbit < otp.cr3bp.CR3BPProblem
    % This preset builds a circular earth orbit in CR3BP based on
    % the equations derived in :cite:p:She20.

       methods
           function obj = CircularEarthOrbit(varargin)
            % Create the CircularEarthOrbit CR3BP problem object.
            %
            % Parameters
            % ----------
            % OrbitalRadius : numeric(1, 1)
            %    The radius of the orbit above Earth's surface in km.

            p = inputParser();
            p.KeepUnmatched = true;
            p.addParameter('OrbitalRadius', 340, @isnumeric);
            p.parse(varargin{:});
            results = p.Results;
            varargin = [fieldnames(p.Unmatched), struct2cell(p.Unmatched)].';

            equatorialRadius = 6378;
            earthMoonDist = 385000;
            orbitalradius = results.OrbitalRadius;

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

            % derive the orbital period
            period = sqrt(((abs(delta))^3)/(1 - mu))*2*pi;

            y0    = [x0; 0; 0; 0; y0; 0];
            tspan = [0, period];
            params = otp.cr3bp.CR3BPParameters('Mu', mu, 'SoftFactor', 1e-3, varargin{:});
            obj = obj@otp.cr3bp.CR3BPProblem(tspan, y0, params);            
        end
    end
end
