classdef Canonical < otp.lorenz63.Lorenz63Problem
    % Original Lorenz '63 preset presented in :cite:p:`Lor63`
    % which uses time span $t \in [0, 60]$, $\sigma = 10$, $\rho = 28$, 
    % $\beta = 8/3$, and intial conditions $y_0 = [0, 1, 0]^T$.

    methods
        function obj = Canonical(varargin)
            % Create the Canonical Lorenz '63 problem object.
            %
            % Parameters
            % ----------
            % varargin
            %    A variable number of name-value pairs. The accepted names are
            %
            %    - ``sigma`` – Value of $\sigma$.
            %    - ``rho`` – Value of $\rho$.
            %    - ``beta`` – Value of $\beta$.
            %
            % Returns
            % -------
            % obj : Lorenz63Problem
            %    The constructed problem.
            
            y0    = [0; 1; 0];
            tspan = [0 60];
            params = otp.lorenz63.Lorenz63Parameters('Sigma', 10, 'Rho', 28, 'Beta', 8/3, varargin{:});
            
            obj = obj@otp.lorenz63.Lorenz63Problem(tspan, y0, params);            
        end
    end
end
