classdef Canonical < otp.lorenz63.Lorenz63Problem
    % [Name]
    %  Canonical
    %
    % [Description]
    %  This is the original problem presented in the literature.
    %  The initial condition is purposefully outside of the trapping region, but converges to it quite quickly.
    %
    % [NoVars]
    %  3
    %
    % [Properties]
    %  Chaotic
    %
    % [Usage]
    %
    methods
        function obj = Canonical(sigma, rho, beta)
            if nargin < 1
                sigma = 10;
            end
            
            if nargin < 2
                rho = 28;
            end
            
            if nargin < 3
                beta = 8/3;
            end
            
            params.sigma = sigma;
            params.rho   = rho;
            params.beta  = beta;
            
            y0    = [0; 1; 0];
            tspan = [0 60];
            
            obj = obj@otp.lorenz63.Lorenz63Problem(tspan, y0, params);            
        end
    end
end
