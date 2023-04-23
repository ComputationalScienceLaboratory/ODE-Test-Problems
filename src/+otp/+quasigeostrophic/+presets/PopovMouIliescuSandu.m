classdef PopovMouIliescuSandu < otp.quasigeostrophic.QuasiGeostrophicProblem
    methods
        function obj = PopovMouIliescuSandu(varargin)
            
            defaultsize = [255, 511];

            Re = 450;
            Ro = 0.0036;
            
            p = inputParser;
            addParameter(p, 'ReynoldsNumber', Re);
            addParameter(p, 'RossbyNumber', Ro);
            addParameter(p, 'Size', defaultsize);

            parse(p, varargin{:});
            
            s = p.Results;

            nx = s.Size(1);
            ny = s.Size(2);
            
            params = otp.quasigeostrophic.QuasiGeostrophicParameters;
            params.Nx = nx;
            params.Ny = ny;
            params.ReynoldsNumber = s.ReynoldsNumber;
            params.RossbyNumber   = s.RossbyNumber;
            params.ADLambda = 1;
            params.ADPasses = 4;
            
            %% Load initial conditions

            % OCTAVE BUG: Octave gives a warning on loading the data, even
            % though MATLAB supports this type of private folder loading
            
            spy0s = load('PMISQGICsp.mat');
            psi0 = reshape(double(spy0s.y0), 255, 511);
            
            psi0 = otp.quasigeostrophic.QuasiGeostrophicProblem.resize(psi0, s.Size);
            psi0 = reshape(psi0, [], 1);
            
            %% Do the rest
            
            sixHours = 6*80/176251.2;
            
            tspan = [100, 100 + sixHours];
            
            obj = obj@otp.quasigeostrophic.QuasiGeostrophicProblem(tspan, ...
                psi0, params);
            
        end
    end
end
