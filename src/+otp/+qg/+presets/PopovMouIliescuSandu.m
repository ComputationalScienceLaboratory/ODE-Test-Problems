classdef PopovMouIliescuSandu < otp.qg.QuasiGeostrophicProblem
    methods
        function obj = PopovMouIliescuSandu

            Re = 450;
            Ro = 0.0036;
            
            [nx, ny] = name2size('huge');

            params.nx = nx;
            params.ny = ny;
            params.Re = Re;
            params.Ro = Ro;
            
            %% Load initial conditions
            
            spy0s = load('PMISQGICsp.mat');
            psi0 = double(spy0s.y0);
            
            %% Do the rest
            
            sixHours = 6*80/176251.2;
            
            tspan = [100, 100 + sixHours];
            
            obj = obj@otp.qg.QuasiGeostrophicProblem(tspan, ...
                psi0, params);
            
        end
    end
end
