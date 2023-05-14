classdef Canonical < otp.kortewegdevries.KortewegdeVriesProblem
    methods
        function obj = Canonical(varargin)

            Domain = [-10, 10];
            Nx = 200;
            theta = 0;
            nu = -1;
            alpha = -3;
            rho = 0;
            uinit = @(x) 6*(sech(x).^2);

            p = inputParser;
            addParameter(p, 'Domain', Domain);
            addParameter(p, 'Nx', Nx);
            addParameter(p, 'InitialCondition', uinit);
            addParameter(p, 'Theta', theta);
            addParameter(p, 'Alpha', alpha);
            addParameter(p, 'Nu', nu);
            addParameter(p, 'Rho', rho);

            parse(p, varargin{:});
            
            s = p.Results;
            
            params = otp.kortewegdevries.KortewegdeVriesParameters;
            params.Domain = s.Domain;
            params.Nx = s.Nx;
            params.InitialCondition = s.InitialCondition;
            params.Theta = s.Theta;
            params.Alpha = s.Alpha;
            params.Nu = s.Nu;
            params.Rho = s.Rho;
            
            %% Construct initial conditions
            
            X = linspace(params.Domain(1), params.Domain(2), params.Nx + 1).';
            u0 = params.InitialCondition(X(1:params.Nx));
            
            %% Do the rest
            
            tspan = [0, 2];
            obj = obj@otp.kortewegdevries.KortewegdeVriesProblem(tspan, u0, params);
            
        end
    end
end
