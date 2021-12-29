classdef Decay < otp.brusselator.BrusselatorProblem
    %DECAY Rapid descent to a fixed point
    %
    methods
        function obj = Decay
            params = otp.brusselator.BrusselatorParameters;
            params.A = 1;
            params.B = 1.7;
            
            y0 = [1; 1];
            tspan = [0 75];
            
            obj = obj@otp.brusselator.BrusselatorProblem(tspan, y0, params);
        end
    end
end
