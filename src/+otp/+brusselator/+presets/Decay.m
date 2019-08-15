classdef Decay < otp.brusselator.BrusselatorProblem
    % [Name]
    %  Decay
    %
    % [Description]
    %  Rapid descent to a fixed point
    %
    % [NoVars]
    %  2
    %
    % [Citation]
    %
    methods
        function obj = Decay
            params.a = 1;
            params.b = 1.7;
            
            y0 = [1; 1];
            tspan = [0 75];
            
            obj = obj@otp.brusselator.BrusselatorProblem(tspan, y0, params);
        end
    end
end
