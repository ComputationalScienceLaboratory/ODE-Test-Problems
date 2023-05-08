classdef Orbit < otp.nbody.NBodyProblem
    methods
        function obj = Orbit()     
            params = otp.nbody.NBodyParameters;
            params.SpatialDim = otp.utils.PhysicalConstants.TwoD;
            params.Masses = [10; 10];
            params.GravitationalConstant = 1;
            params.SofteningLength = 0;

            y0 = [-2; 0; 2; 0; 0; -1; 0; 1];

            tspan = [0, 30];
            
            obj = obj@otp.nbody.NBodyProblem(tspan, y0, params);
        end
    end
end
