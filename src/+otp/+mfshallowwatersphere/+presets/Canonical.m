classdef Canonical < otp.mfshallowwatersphere.MFShallowWaterSphereProblem
    methods
        function obj = Canonical(varargin)
            
            load('nodes100.mat', 'x', 'y', 'z');

            % mean water height
            H = 5.768e4;
            % earth gravity
            g = otp.utils.PhysicalConstants.EarthGravity;
            % radius of the earth
            a = otp.utils.PhysicalConstants.EarthRadius;
            % initial velocity for the perturbation
            u0 = 20;
            % Angular velocity of the earth
            Omega = otp.utils.PhysicalConstants.EarthAngularVelocity;

            coriolisForce = 2*Omega*z;

            params.gravity = otp.utils.PhysicalConstants.EarthGravity;
            params.radius = a;
            params.angularSpeed = Omega;
            params.coriolisForce = coriolisForce;

            params.x = x;
            params.y = y;
            params.z = z;

            params.rbfradius = 2.0;
            params.rbf = @otp.utils.rbf.buhmann3;

            % convert from Cartesian to spherical coordinates
            theta = atan2(z, sqrt(x.^2 + y.^2));
            lambda = atan2(y, x);

            %% Define the initial conditions
            % first get a stableish Rossby-Haurwitz wave with a wave number
            % of R = 7
            R = 7;
            [h, zonalwind, meridionalwind] = getrossbyhaurwitzwave(x, y, z, Omega, a, g, R);

            % then, define perturbations to this wave in terms of the T-Z
            % initial condition.
            hpert              = (1/g)*(H + 2*Omega*a*u0*( sin(theta).^3 ).*cos(theta).*sin(lambda));
            zonalwindpert      = (-3*u0*sin(theta).*( cos(theta).^2 ).*sin(lambda) + u0*( sin(theta).^3 ).*sin(lambda));
            meridionalwindpert = (u0*( sin(theta).^2 ).*cos(lambda));

            % remove the excess height and velocity
            %hpert = hpert - mean(hpert);
            %zonalwindpert = zonalwindpert - mean(zonalwindpert);
            %meridionalwindpert = meridionalwindpert - mean(meridionalwindpert);

            % mixing coefficient
            alpha = 0.1;

            % perturb the R-H wave
            h              = alpha*h              + (1 - alpha)*hpert;
            zonalwind      = alpha*zonalwind      + (1 - alpha)*zonalwindpert;
            meridionalwind = alpha*meridionalwind + (1 - alpha)*meridionalwindpert;

            % finally, convert to Cartesian coordinates
            [u, v, w] = velocitytocartesian(x, y, z, zonalwind, meridionalwind);

            huv0 = [h; u; v; w];
            
            %% Do the rest

            oneday = 24*60*60;
            
            tspan = [0, oneday];
            
            obj = obj@otp.mfshallowwatersphere.MFShallowWaterSphereProblem(tspan, ...
                huv0, params);
            
        end
    end
end
