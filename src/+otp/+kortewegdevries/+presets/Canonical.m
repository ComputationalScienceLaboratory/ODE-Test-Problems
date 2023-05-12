classdef Canonical < otp.kortewegdevries.KortewegdeVriesProblem
    methods
        function obj = Canonical(varargin)

            Domain = [-10, 10];
            Nx = 200;
            Theta = 0;
            Nu = -1;
            Alpha = -3;
            Rho = 0;
            Uinit = @(x) 6*(sech(x).^2);

            p = inputParser;
            addParameter(p, 'Domain', Domain);
            addParameter(p, 'Nx', Nx);
            addParameter(p, 'InitialCondition', Uinit);
            addParameter(p, 'Theta', Theta);
            addParameter(p, 'Alpha', Alpha);
            addParameter(p, 'Nu', Nu);
            addParameter(p, 'Rho', Rho);

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
            params.Grid = X(1:params.Nx);
            u0 = params.InitialCondition(params.Grid);
            
            %% Do the rest
            
            tspan = [0, 2];
            obj = obj@otp.kortewegdevries.KortewegdeVriesProblem(tspan, u0, params);
            
        end
    end
end
