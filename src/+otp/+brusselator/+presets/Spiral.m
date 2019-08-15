classdef Spiral < otp.brusselator.BrusselatorProblem
    % [Name]
    %  Spiral
    %
    % [Description]
    %  Rapid decay into a fixed orbit
    %
    % [NoVars]
    %  2
    %
    % [Citation]
    %
    methods
        function obj = Spiral
            params.a = 1;
            params.b = 2;
            
            y0 = [2; 1];
            tspan = [0 75];
            
            obj = obj@otp.brusselator.BrusselatorProblem(tspan, y0, params);
        end
    end
end
