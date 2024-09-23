classdef Canonical < otp.ascherlineardae.AscherLinearDAEProblem
    % The problem defined by Ascher in :cite:p:`Asc89` (sec. 2) which uses time span $t ∈ [0, 1]$ and intial condition
    % $[y_0, z_0]^T = [1, β]^T$.

    methods
        function obj = Canonical(varargin)
            % Create the canonical Ascher linear DAE problem object.
            %
            % Parameters
            % ----------
            % varargin
            %    A variable number of name-value pairs. The accepted names are
            %
            %    - ``Beta`` – Value of $β$.
            
            params = otp.ascherlineardae.AscherLinearDAEParameters('Beta', 1, varargin{:});
            y0 = [1; params.Beta];
            tspan = [0.0; 1.0];
            obj = obj@otp.ascherlineardae.AscherLinearDAEProblem(tspan, y0, params);
        end
    end
end
