classdef Canonical < otp.swe.SWEonSphere
    methods
        function obj = Canonical(varargin)

            nl = 33;
            nm = 32;

            g = otp.utils.PhysicalConstants.EarthGravity;
            a = otp.utils.PhysicalConstants.EarthRadius;
            omega = otp.utils.PhysicalConstants.EarthAngularVelocity;
            phi = 5.768e4;
            uinit = 1;

            p = inputParser;
            addParameter(p, 'LatitudeGridSize', nl);
            addParameter(p, 'MeridianGridSize', nm);
            addParameter(p, 'Gravity', g);
            addParameter(p, 'Radius', a);
            addParameter(p, 'AngularSpeed', omega);
            addParameter(p, 'SpecificEnergy', phi);
            addParameter(p, 'InitialVelocity', uinit);

            parse(p, varargin{:});

            s = p.Results;
            
            params = struct('nl', s.LatitudeGridSize, ...
                'nm', s.MeridianGridSize, ...
                'g', s.Gravity, ...
                'a', s.Radius, ...
                'omega', s.AngularSpeed, ...
                'phi', s.SpecificEnergy, ...
                'uinit', s.InitialVelocity);
            
            
            % Inital conditions
            [la, me, ~, ~] = otp.swe.SWEonSphere.makeMesh(params.nl, params.nm);

            % Some comments are for poles

            mep = [me(1) me(end)];
            menp = me(2:end-1);
            lap = pi/2;

            h = 1/params.g*(params.phi + 2*params.a*params.omega*params.um0*(0.2*(sin(menp).^3).*(cos(la).') + otp.swe.presets.Canonical.tropicalTsunami(la, menp)));            
            u = params.um0*(sin(menp).*sin(la.')).*(-3*cos(menp).^2 + sin(menp).^2);
            v = params.um0*((sin(menp).^2).*cos(la.'));

            hp = 1/params.g*(params.phi + 2*params.a*params.omega*params.um0*(sin(mep).^3)*cos(lap));
            up = 0*params.um0*(sin(mep).*sin(lap)).*(-3*cos(mep).^2 + sin(mep).^2);
            vp = params.um0*((sin(mep).^2).*cos(lap));

            h0 = [hp(1); h(:); hp(2)];
            u0 = [up(1); u(:); up(2)];
            v0 = [vp(1); v(:); vp(2)];

            y0 = [h0; u0; v0];

            fourYears = 1*3600*24*365.25*4;
            tspan = [0, fourYears];
            obj = obj@otp.swe.SWEonSphere(tspan, y0, params);

        end

    end

    methods (Static)

        function h = tropicalTsunami(la, me)

            gla = la(round(length(la)/2));
            gme = me(round(length(me)/2));

            ladiff = min([la - gla; 2*pi - la + gla]).';
            mediff = me - gme;

            h = -exp(-(ladiff.^2 + mediff.^2)/0.1);

        end

        function h = randTropicalTsunami(la, me)

            gla = randsample(la, 1);

            lme = length(me);
            ind = 1:lme;
            cutoff = ceil(3*lme/8);
            ind = ind(cutoff:end - cutoff);

            gme = randsample(me(ind), 1);

            ladiff = min([la - gla; 2*pi - la + gla]).';
            mediff = me - gme;

            h = -exp(-(ladiff.^2 + mediff.^2)/0.1);

        end

    end
end
