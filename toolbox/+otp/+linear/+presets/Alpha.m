classdef Alpha < otp.linear.LinearProblem
    %ALPHA
    %
    methods
        function obj = Alpha(varargin)
            p = inputParser();
            p.addParameter('Alpha', 45);
            p.addParameter('N', 10);
            p.addParameter('Range', [1e-4, 1e4]);
            p.addParameter('Sparse', true);
            p.parse(varargin{:});
            results = p.Results;

            z = logspace(log10(results.Range(1)), log10(results.Range(end)), results.N) ...
                * (1i * sind(results.Alpha) - cosd(results.Alpha));

            if results.Sparse
                lambda = spdiags(z.', 0, results.N, results.N);
            else
                lambda = diag(z);
            end

            tspan = [0, 1];
            y0 = ones(results.N, 1);
            params = otp.linear.LinearParameters('Lambda', {lambda});
            obj = obj@otp.linear.LinearProblem(tspan, y0, params);
        end
    end
end
