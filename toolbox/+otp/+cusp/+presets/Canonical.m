classdef Canonical < otp.cusp.CUSPProblem
    % The CUSP configuration from :cite:p:`HW96` (pp. 147-148) which uses time span $t ∈ [0, 1.1]$, $N = 32$ grid cells,
    % and initial conditions
    %
    % $$
    % y_i(0) &= 0 ,\\
    % a_i(0) &= -2 \cos\left( \frac{2 i π}{N} \right), \\
    % b_i(0) &= 2 \sin\left( \frac{2 i π}{N} \right), \\
    % $$
    %
    % for $i = 1, …, N$. The parameters are $ε = 10^{-4}$ and $σ = \frac{1}{144}$.
    
    methods
        function obj = Canonical(varargin)
            % Create the Canonical CUSP problem object.
            %
            % Parameters
            % ----------
            % varargin
            %    A variable number of name-value pairs. The accepted names are
            %
            %    - ``N`` – The number of cells in the spatial discretization.
            %    - ``epsilon`` – Value of $ε$.
            %    - ``sigma`` – Value of $σ$.

            p = inputParser;
            p.KeepUnmatched = true;
            p.addParameter('N', 32);
            p.parse(varargin{:});
            n = p.Results.N;
            
            ang = 2 * pi * (1:n).' / n;
            y0 = zeros(n, 1);
            a0 = -2 * cos(ang);
            b0 = 2 * sin(ang);

            u0 = [y0; a0; b0];
            tspan = [0; 1.1];

            unmatched = namedargs2cell(p.Unmatched);
            params = otp.cusp.CUSPParameters('Epsilon', 1e-4, 'Sigma', 1/144, unmatched{:});
            
            obj = obj@otp.cusp.CUSPProblem(tspan, u0, params);
        end
    end
end
