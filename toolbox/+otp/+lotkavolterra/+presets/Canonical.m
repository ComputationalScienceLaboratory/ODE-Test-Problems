classdef Canonical  < otp.lotkavolterra.LotkaVolterraProblem
    % Canonical preset for the Lotka-Volterra problem. The initial conditions are $y_0 = [1, 2]^T$, and the parameters are
    % $\alpha = 1$, $\beta = 1$, $\delta = 1$, and $\gamma = 1$. This preset 
    % has an equilibrium at $y = [1, 1]^T$.

    methods
        function obj = Canonical(varargin)
            % Create the canonical Lotka-Volterra problem object.
            %
            % Parameters
            % ----------
            % varargin
            %    A variable number of name-value pairs. The accepted names are
            %
            %   - ``PreyBirthRate`` – Value of $\alpha$.
            %   - ``PreyDeathRate`` – Value of $\beta$.
            %   - ``PredatorDeathRate`` – Value of $\delta$.
            %   - ``PredatorBirthRate`` – Value of $\gamma$.

            y0 = [1; 2];
            tspan = [0 50];
            params = otp.lotkavolterra.LotkaVolterraParameters( ...
                'PreyBirthRate', 1, ...
                'PreyDeathRate', 1, ...
                'PredatorDeathRate', 1, ...
                'PredatorBirthRate', 1, ...
                varargin{:});
            obj = obj@otp.lotkavolterra.LotkaVolterraProblem(tspan, y0, params);
        end
    end
    
end
