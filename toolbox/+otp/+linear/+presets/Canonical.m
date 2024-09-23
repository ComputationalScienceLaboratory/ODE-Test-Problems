classdef Canonical < otp.linear.LinearProblem
    % A scalar linear preset with $t ∈ [0, 1]$, $y_0 = 1$, and $Λ_1 = -1$.

    methods
        function obj = Canonical(varargin)
            % Create the canonical linear problem object.
            %
            % Parameters
            % ----------
            % varargin
            %    A variable number of name-value pairs. The accepted names are
            %
            %    - ``Lambda`` – Cell array of matrices for each partition $Λ_i y$.

            params = otp.linear.LinearParameters('Lambda', {-1}, varargin{:});
            tspan = [0, 1];
            y0 = ones(size(params.Lambda{1}, 1), 1);
            obj = obj@otp.linear.LinearProblem(tspan, y0, params);
        end
    end
end
