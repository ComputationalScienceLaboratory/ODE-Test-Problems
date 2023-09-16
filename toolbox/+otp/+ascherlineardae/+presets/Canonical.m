classdef Canonical < otp.ascherlineardae.AscherLinearDAEProblem
    % The problem defined by Uri Ascher in :cite:p:`Asc89` (sec. 2) 
    % which uses timespan $t \in [0, 1]$  and  $\beta = 1 $.
    % 
    methods
        function obj = Canonical(varargin)
            % Create the Canonical CUSP problem object.
            %
            % Parameters
            % ----------
            % varargin
            %    A variable number of name-value pairs. The accepted names are
            %
            %    - ``Beta`` – The parameter of the Ascher linear DAE problem.
            
            p = inputParser;
            p.addParameter('beta', 1);
            p.parse(varargin{:});
            opts = p.Results;
            
            params      = otp.ascherlineardae.AscherLinearDAEParameters;
            params.Beta = opts.beta;
            
            y0    = [1; params.Beta];
            tspan = [0.0; 1.0];
            
            obj = obj@otp.ascherlineardae.AscherLinearDAEProblem(tspan, y0, params);
        end
    end
end
