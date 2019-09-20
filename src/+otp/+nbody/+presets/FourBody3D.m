classdef FourBody3D < otp.nbody.NBodyProblem
    methods
        function obj = FourBody3D()            
            params.spacialDim = 3;
            params.masses = [8; 10; 12; 14];
            params.gravitationalConstant = 1;
            params.softeningLength = 0;
            
            positions = [ ...
                0; 0; 0; ...
                4; 3; 1; ...
                3; -4; -2; ...
                -3; 4; 5];
            velocities = zeros(12, 1);
            y0 = [positions; velocities];

            tspan = [0, 15];
            
            obj = obj@otp.nbody.NBodyProblem(tspan, y0, params);
        end
    end
end