classdef Spiral < otp.brusselator.BrusselatorProblem
    %SPIRAL Brusselator preset with a phase plot that spirals into a stable orbit
    %   See also otp.brusselator.BrusselatorProblem
    methods
        function obj = Spiral
            params = otp.brusselator.BrusselatorParameters;
            params.A = 1;
            params.B = 2;
            
            y0 = [2; 1];
            tspan = [0, 75];
            
            obj = obj@otp.brusselator.BrusselatorProblem(tspan, y0, params);
        end
    end
end
