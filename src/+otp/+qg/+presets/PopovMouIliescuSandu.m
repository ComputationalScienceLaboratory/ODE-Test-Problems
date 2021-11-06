classdef PopovMouIliescuSandu < otp.qg.QuasiGeostrophicProblem
    methods
        function obj = PopovMouIliescuSandu(varargin)
            
            defaultsize = 'huge';

            Re = 450;
            Ro = 0.0036;
            
            p = inputParser;
            addParameter(p, 'ReynoldsNumber', Re);
            addParameter(p, 'RossbyNumber', Ro);
            addParameter(p, 'Size', defaultsize);

            parse(p, varargin{:});
            
            s = p.Results;

            [nx, ny] = otp.qg.QuasiGeostrophicProblem.name2size(s.Size);
            
            params.nx = nx;
            params.ny = ny;
            params.Re = s.ReynoldsNumber;
            params.Ro = s.RossbyNumber;
            
            %% Load initial conditions
            
            spy0s = load('PMISQGICsp.mat');
            psi0 = double(spy0s.y0);
            
            if ~ strcmp(defaultsize, s.Size)
                psi0 = otp.qg.QuasiGeostrophicProblem.relaxprolong(psi0, s.Size);
            end
            
            %% Do the rest
            
            sixHours = 6*80/176251.2;
            
            tspan = [100, 100 + sixHours];
            
            obj = obj@otp.qg.QuasiGeostrophicProblem(tspan, ...
                psi0, params);
            
        end
    end
end
