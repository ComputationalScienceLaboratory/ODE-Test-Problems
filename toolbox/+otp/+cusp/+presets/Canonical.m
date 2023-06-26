classdef Canonical < otp.cusp.CUSPProblem
    % The CUSP configuration from :cite:p:`HW96` (pp. 147-148).
    
    methods
        function obj = Canonical(varargin)
            % Create the Canonical CUSP problem object.
            %
            % Parameters
            % ----------
            % varargin
            %    A variable number of name-value pairs. The accepted names are
            %
            %    - ``N`` -- The number of cells in the spatial discretization.
            %    - ``epsilon`` -- Value of $\varepsilon$.
            %    - ``sigma`` -- Value of $\sigma$.
            %
            % Returns
            % -------
            % obj : CUSPProblem
            %    The constructed problem.

            p = inputParser;
            p.addParameter('N', 32);
            p.addParameter('epsilon', 1e-4);
            p.addParameter('sigma', 1/144);
            p.parse(varargin{:});
            opts = p.Results;
            
            params = otp.cusp.CUSPParameters;
            params.Epsilon = opts.epsilon;
            params.Sigma = opts.sigma;
            
            ang = 2 * pi / opts.N * (1:opts.N).';
            y0 = zeros(opts.N, 1);
            a0 = -2*cos(ang);
            b0 = 2*sin(ang);

            u0 = [y0; a0; b0];
            tspan = [0; 1.1];
            
            obj = obj@otp.cusp.CUSPProblem(tspan, u0, params);
        end
    end
end
