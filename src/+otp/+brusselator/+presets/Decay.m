classdef Decay < otp.brusselator.BrusselatorProblem
    %DECAY Brusselator preset with a solution that decays towards a steady state
    %   See also otp.brusselator.BrusselatorProblem
    methods
        function obj = Decay
            params = otp.brusselator.BrusselatorParameters;
            params.A = 1;
            params.B = 1.7;
            
            y0 = [1; 1];
            tspan = [0, 50];
            
            obj = obj@otp.brusselator.BrusselatorProblem(tspan, y0, params);
        end
    end
end
