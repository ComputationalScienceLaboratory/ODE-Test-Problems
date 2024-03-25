% From I.2.4 of Geometric Numerical Integration
classdef OuterSolarSystem < otp.nbody.NBodyProblem
    methods
        function obj = OuterSolarSystem()
            positions = [0; 0; 0; ...
                -3.5023653; -3.8169847; -1.5507963; ...
                9.0755314; -3.0458353; -1.6483708; ...
                8.3101420; -16.2901086; -7.2521278; ...
                11.4707666; -25.7294829; -10.8169456; ...
                -15.5387357; -25.2225594; -3.1902382];
            velocities = [0; 0; 0; ...
                0.00565429; -0.00412490; -0.00190589; ...
                0.00168318; 0.00483525; 0.00192462; ...
                0.00354178; 0.00137102; 0.00055029; ...
                0.00288930; 0.00114527; 0.00039677; ...
                0.00276725; -0.00170702; -0.00136504];
            y0 = [positions; velocities];
            tspan = [0, 2e5];
            params = otp.nbody.NBodyParameters( ...
                'SpatialDim', otp.utils.PhysicalConstants.ThreeD, ...
                'Masses', [1.00000597682, 0.000954786104043, 0.000285583733151, 0.0000437273164546, ...
                0.0000517759138449, 1 / 1.3e8], ...
                'GravitationalConstant', 2.95912208286e-4, ...
                'SofteningLength', 0);
            obj = obj@otp.nbody.NBodyProblem(tspan, y0, params);
        end
    end
end
