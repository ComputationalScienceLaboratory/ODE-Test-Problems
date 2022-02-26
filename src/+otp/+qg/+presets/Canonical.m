classdef Canonical < otp.qg.QuasiGeostrophicProblem
    methods
        function obj = Canonical(varargin)

            Re = 450;
            Ro = 0.0036;
            
            p = inputParser;
            addParameter(p, 'ReynoldsNumber', Re);
            addParameter(p, 'RossbyNumber', Ro);
            addParameter(p, 'Size', [255, 511]);

            parse(p, varargin{:});
            
            s = p.Results;
            
            nx = s.Size(1);
            ny = s.Size(2);
            
            params = otp.qg.QuasiGeostrophicParameters;
            params.Nx = nx;
            params.Ny = ny;
            params.ReynoldsNumber = s.ReynoldsNumber;
            params.RossbyNumber   = s.RossbyNumber;
            params.ADLambda = 1;
            params.ADPasses = 4;
            
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
