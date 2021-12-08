classdef Canonical < otp.mfshallowwatersphere.MFShallowWaterSphereProblem
    methods
        function obj = Canonical(varargin)
            
            load('mesh4000.mat', 'lambda', 'phi');

            % mean water height
            H = 5.768e4;
            % earth gravity
            g = 9.8;
            % radius of the earth
            a = 6.370e6;
            % initial velocity
            u0 = 20;
            % Angular speed of the earth
            Omega = 7.292e-5;


            params = struct;
            params.gravity = otp.utils.PhysicalConstants.EarthGravity;
            params.radius = a;
            params.angularSpeed = Omega;

            params.lambda = lambda;
            params.phi = phi;
            
            phiT = phi.';
            lambdaT = lambda.';

            h = (1/g)*(H + 2*Omega*a*u0*( sin(phiT).^3 ).*cos(phiT).*sin(lambdaT));
            u = -3*u0*sin(phiT).*( cos(phiT).^2 ).*sin(lambdaT) + u0*( sin(phiT).^3 ).*sin(lambdaT);
            v = u0*( sin(phiT).^2 ).*cos(lambdaT);

            huv0 = [h; u; v];
            
            %% Do the rest

            oneday = 24*60*60;
            
            tspan = [0, oneday];
            
            obj = obj@otp.mfshallowwatersphere.MFShallowWaterSphereProblem(tspan, ...
                huv0, params);
            
        end
    end
end
