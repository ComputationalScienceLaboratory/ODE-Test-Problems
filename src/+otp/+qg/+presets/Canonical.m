classdef Canonical < otp.qg.QuasiGeostrophicProblem
    methods
        function obj = Canonical(varargin)

            Re = 450;
            Ro = 0.0036;
            
            p = inputParser;
            addParameter(p, 'ReynoldsNumber', Re);
            addParameter(p, 'RossbyNumber', Ro);
            addParameter(p, 'Size', 'huge');
            addParameter(p, 'Lambda', 0.4);

            parse(p, varargin{:});
            
            s = p.Results;
            
            [nx, ny] = otp.qg.QuasiGeostrophicProblem.name2size(s.Size);
            
            les = struct('lambda', s.Lambda);

            params.nx = nx;
            params.ny = ny;
            params.Re = s.ReynoldsNumber;
            params.Ro = s.RossbyNumber;
            params.les = les;
            
            %% Construct initial conditions

            psi0 = zeros(nx, ny);

            psi0 = psi0(:);
            
            %% Do the rest
            
            tspan = [0, 100];
            
            obj = obj@otp.qg.QuasiGeostrophicProblem(tspan, ...
                psi0, params);
            
        end
    end
end
