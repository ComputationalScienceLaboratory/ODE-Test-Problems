classdef LimitCycle < otp.lorenz63.Lorenz63Problem
    % [Name]
    %  Limit Cycle
    %
    % [Description]
    %  A non-chaotic set of parameters for the problem to showcase potential periodic behavior.
    %
    % [NoVars]
    %  3
    %
    % [Properties]
    %
    % [Usage]
    %
    % [Citation]
    %  Strogatz p 341
    %
    methods
        function obj = LimitCycle
            sigma = 10;
            rho   = 350;
            beta  = 8/3;
    
            params.sigma = sigma;
            params.rho   = rho;
            params.beta  = beta;
            
            % We will use Lorenz's initial conditions and timespan as Strogatz
            % does not specify those in his book.
            
            y0    = [0; 1; 0];
            tspan = [0 60];
            
            obj = obj@otp.lorenz63.Lorenz63Problem(tspan, y0, params);            
        end
    end
end
