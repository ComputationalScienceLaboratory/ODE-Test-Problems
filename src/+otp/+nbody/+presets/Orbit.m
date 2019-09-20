classdef Orbit < otp.nbody.NBodyProblem
    methods
        function obj = Orbit()            
            params.spacialDim = 2;
            params.masses = [10; 10];
            params.gravitationalConstant = 1;
            params.softeningLength = 0;

            y0 = [-2; 0; 2; 0; 0; -1; 0; 1];

            tspan = [0, 30];
            
            obj = obj@otp.nbody.NBodyProblem(tspan, y0, params);
        end
    end
end