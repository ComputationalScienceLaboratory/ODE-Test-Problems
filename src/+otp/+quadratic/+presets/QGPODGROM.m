classdef QGPODGROM < otp.quadratic.QuadraticProblem

    methods
        function obj = QGPODGROM
            tspan = [0, 80/(365.25*20.12)];
            
            s = load('PMISr100sp.mat');
            
            params.a = double(s.b);
            params.B = double(s.A);
            params.C = double(s.B);
            y0 = s.a0;
            
            obj = obj@otp.quadratic.QuadraticProblem(tspan, y0, params);
        end
    end

end
