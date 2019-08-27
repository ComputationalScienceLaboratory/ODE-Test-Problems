classdef Surprise < otp.lorenz63.Lorenz63Problem
    % [Name]
    %  Surprise
    %
    % [Description]
    %  Strogatz's `surprise'
    %
    % [NoVars]
    %  3
    %
    % [Properties]
    %
    % [Usage]
    %
    % [Citation]
    %  Strogatz p 351
    %
    methods
        function obj = Surprise
            sigma = 10;
            rho   = 100;
            beta  = 8/3;

            params.sigma = sigma;
            params.rho   = rho;
            params.beta  = beta;
            
            % Hand-picked initial conditions with the canonical timespan
            
            y0    = [2; 1; 1];
            tspan = [0 60];
            
            obj = obj@otp.lorenz63.Lorenz63Problem(tspan, y0, params);
        end
    end
end
