classdef Periodic < otp.brusselator.BrusselatorProblem
    % [Name]
    %  Periodic
    %
    % [Description]
    %  A periodic cycle.
    %
    % [NoVars]
    %  2
    %
    % [Citation]
    %
    methods
        function obj = Periodic
            params = otp.brusselator.BrusselatorParameters;
            params.ReactionRateA = 1;
            params.ReactionRateB = 4.5;
            
            y0 = [2; 1];
            tspan = [0 50];
            
            obj = obj@otp.brusselator.BrusselatorProblem(tspan, y0, params);
        end
    end
end
