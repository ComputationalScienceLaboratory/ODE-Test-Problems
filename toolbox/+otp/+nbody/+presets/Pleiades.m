classdef Pleiades < otp.nbody.NBodyProblem
    methods
        function obj = Pleiades()
            positions = [3; 3; 3; -3; -1; 2; -3; 0; 2; 0; -2; -4; 2; 4];
            velocities = [0; 0; 0; 0; 0; 0; 0; -1.25; 0; 1; 1.75; 0; -1.5; 0];
            y0 = [positions; velocities];
            tspan = [0, 3];
            params = otp.nbody.NBodyParameters( ...
                'SpatialDim', otp.utils.PhysicalConstants.TwoD, ...
                'Masses', 1:7, ...
                'GravitationalConstant', 1, ...
                'SofteningLength', 0);
            obj = obj@otp.nbody.NBodyProblem(tspan, y0, params);
        end
    end
end
