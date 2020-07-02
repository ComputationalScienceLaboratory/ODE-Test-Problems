classdef Canonical < otp.ascherlineardae.AscherLinearDAEProblem
    methods
        function obj = Canonical
            tspan = [0.0, 1];
            

            params.beta = 0.5;

            y0 = [1,0.5]';

            obj = obj@otp.ascherlineardae.AscherLinearDAEProblem(tspan, y0, params);            
        end
    end
end
