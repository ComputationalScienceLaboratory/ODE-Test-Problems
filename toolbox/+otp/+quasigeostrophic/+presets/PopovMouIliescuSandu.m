classdef PopovMouIliescuSandu < otp.quasigeostrophic.QuasiGeostrophicProblem
    methods
        function obj = PopovMouIliescuSandu(varargin)
            sixHours = 6*80/176251.2;
            tspan = [100, 100 + sixHours];

            params = otp.quasigeostrophic.QuasiGeostrophicParameters(
                'Nx', 255, ...
                'Ny', 511, ...
                'ReynoldsNumber', 450, ...
                'RossbyNumber', 0.0036, ...
                'ADLambda', 1, ...
                'ADPasses', 4, ...
                varargin{:});

            % OCTAVE BUG: Octave gives a warning on loading the data, even
            % though MATLAB supports this type of private folder loading
            spy0s = load('PMISQGICsp.mat');
            psi0 = reshape(double(spy0s.y0), 255, 511);
            
            psi0 = otp.quasigeostrophic.QuasiGeostrophicProblem.resize(psi0, [params.Nx, params.Ny]);
            psi0 = reshape(psi0, [], 1);
            
            obj = obj@otp.quasigeostrophic.QuasiGeostrophicProblem(tspan, psi0, params);
        end
    end
end
