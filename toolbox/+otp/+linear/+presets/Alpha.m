classdef Alpha < otp.linear.LinearProblem
    % A diagonal linear preset with eigenvalues logarithmically spaced between distances $r_{min}$ and $r_{max}$ from
    % the origin at an angle $α$ measured in degrees clockwise from the negative real axis. It can be used to check for
    % $A(α)$ stability of a time integration scheme. This preset uses $t ∈ [0, 1]$, $y_0 = [1, 1, …, 1]^T$, and
    %
    % $$
    % Λ_1 &= \diag(-r_1 e^{-i π α / 180}, -r_2 e^{-i π α / 180}, …, -r_N e^{-i π α / 180}), \\
    % r_j &= r_{min}^{\frac{N - j}{N - 1}} r_{max}^{\frac{j - 1}{N - 1}}.
    % $$

    methods
        function obj = Alpha(varargin)
            % Create the alpha linear problem object.
            %
            % Parameters
            % ----------
            % varargin
            %    A variable number of name-value pairs. The accepted names are
            %
            %    - ``Alpha`` – The angle $α$ measured in degrees clockwise from the negative real axis.
            %    - ``N`` – The number of eigenvalues $N$.
            %    - ``Range`` – The range $[r_{min}, r_{max}]$ of the eigenvalues.
            %    - ``Sparse`` – If true, the matrix will be in sparse format. Otherwise, it will be dense.

            p = inputParser();
            p.addParameter('Alpha', 0);
            p.addParameter('N', 10);
            p.addParameter('Range', [1e-3, 1e3]);
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
