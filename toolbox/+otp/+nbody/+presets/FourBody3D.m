classdef FourBody3D < otp.nbody.NBodyProblem
    methods
        function obj = FourBody3D()  
            params = otp.nbody.NBodyParameters;
            params.SpatialDim = otp.utils.PhysicalConstants.ThreeD;
            params.Masses = [8; 10; 12; 14];
            params.GravitationalConstant = 1;
            params.SofteningLength = 0;
            
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
