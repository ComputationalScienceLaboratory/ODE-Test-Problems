classdef Spiral < otp.brusselator.BrusselatorProblem
    %SPIRAL Rapid decay into a fixed orbit
    %
    methods
        function obj = Spiral
            params = otp.brusselator.BrusselatorParameters;
            params.A = 1;
            params.B = 2;
            
            y0 = [2; 1];
            tspan = [0 75];
            
            obj = obj@otp.brusselator.BrusselatorProblem(tspan, y0, params);
        end
    end
end
