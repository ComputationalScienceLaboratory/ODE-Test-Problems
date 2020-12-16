classdef L96PODGROM < otp.quadratic.QuadraticProblem
    
    properties
        Projection
        Interpolation
    end

    methods
        function obj = L96PODGROM(r)
            tspan = [0, 0.05];
            
            if nargin < 1
                r = 28;
            end   
            
            s = load('l96_ROM_r28.mat');
            
            params.a = double(s.a(1:r));
            params.B = double(s.B(1:r, 1:r));
            params.C = double(s.C(1:r, 1:r, 1:r));
            
            y0 = 8*ones(40, 1);
            y0(20) = 8.008;
            
            u0 = s.Va*y0;
            
            obj = obj@otp.quadratic.QuadraticProblem(tspan, u0, params);
            
            obj.Projection = s.Va;
            obj.Interpolation = s.V;
        end
    end

end
