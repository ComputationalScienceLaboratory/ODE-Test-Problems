classdef QGPODGROM < otp.quadratic.QuadraticProblem

    methods
        function obj = QGPODGROM(r)
            tspan = [0, 80/(365.25*20.12)];
            
            if nargin < 1
                r = 100;
            end   
            
            s = load('PMISr100sp.mat');
            
            params.a = double(s.b(1:r));
            params.B = double(s.A(1:r, 1:r));
            params.C = double(s.B(1:r, 1:r, 1:r));
            y0 = double(s.a0(1:r));
            
            obj = obj@otp.quadratic.QuadraticProblem(tspan, y0, params);
        end
    end

end
