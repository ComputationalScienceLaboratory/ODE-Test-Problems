classdef Periodic < otp.brusselator.BrusselatorProblem
    %PERIODIC A periodic cycle.
    %
    methods
        function obj = Periodic
            params = otp.brusselator.BrusselatorParameters;
            params.A = 1;
            params.B = 4.5;
            
            y0 = [2; 1];
            tspan = [0 50];
            
            obj = obj@otp.brusselator.BrusselatorProblem(tspan, y0, params);
        end
    end
end
