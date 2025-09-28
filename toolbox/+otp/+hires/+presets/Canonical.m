classdef Canonical < otp.hires.HIRESProblem
    % HIRES preset proposed in :cite:p:`HW96` (pp. 144-145) which uses time span $t ∈ [0, 321.8122]$, initial conditions
    %
    % $$
    % y(0) = [1, 0, 0, 0, 0, 0, 0, 0.0057]^T,
    % $$
    %
    % and parameters
    %
    % $$
    % k_1 &= 1.71, \quad & k_2 &= 0.43, \quad & k_3 &= 8.32, \quad & k_4 &= 0.69, \quad & k_5 &= 0.035, \\
    % k_6 &= 8.32, & k_{+} &= 280, & k_{-} &= 0.69, & k^* &= 0.69, & o_{k_s} &= 0.0007.
    % $$

    methods
        function obj = Canonical(varargin)
            % Create the canonical HIRES problem object.
            %
            % Parameters
            % ----------
            % varargin
            %    A variable number of name-value pairs. The accepted names are
            %
            %    - ``K1`` – Value of $k_1$.
            %    - ``K2`` – Value of $k_2$.
            %    - ``K3`` – Value of $k_3$.
            %    - ``K4`` – Value of $k_4$.
            %    - ``K5`` – Value of $k_5$.
            %    - ``K6`` – Value of $k_6$.
            %    - ``KPlus`` – Value of $k_{+}$.
            %    - ``KMinus`` – Value of $k_{-}$.
            %    - ``KStar`` – Value of $k^*$.
            %    - ``OKS`` – Value of $o_{k_s}$.

            tspan = [0, 321.8122];
            y0 = [1; 0; 0; 0; 0; 0; 0; 0.0057];
            params = otp.hires.HIRESParameters('K1', 1.71, 'K2', 0.43, 'K3', 8.32, 'K4', 0.69, 'K5', 0.035, ...
                'K6', 8.32, 'KPlus', 280, 'KMinus', 0.69, 'KStar', 0.69, 'OKS', 0.0007, varargin{:});
            obj = obj@otp.hires.HIRESProblem(tspan, y0, params);
        end
    end
end