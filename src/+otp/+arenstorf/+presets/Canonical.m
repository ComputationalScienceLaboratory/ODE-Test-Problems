classdef Canonical < otp.arenstorf.ArenstorfProblem
    methods
        function obj = Canonical
            params.m1 = 0.012277471;
            params.m2 = 1-0.012277471;

            y0 = [0.994; 0; 0; -2.00158510637908252240537862224];
            tspan = [0,20];
            
            obj = obj@otp.arenstorf.ArenstorfProblem(tspan, y0, params);
        end

    end
end