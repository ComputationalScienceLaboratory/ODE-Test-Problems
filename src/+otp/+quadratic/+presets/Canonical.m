classdef Canonical < otp.quadratic.QuadraticProblem
    methods
        function obj = Canonical(varargin)
            tspan = [0, 10];
            
            p = inputParser;
            p.addParameter('a', 0);
            p.addParameter('B', 1);
            p.addParameter('C', -1);

            p.parse(varargin{:});
            
            s = p.Results;
            
            params = otp.quadratic.QuadraticParameters;
            params.A = s.a;
            params.B = s.B;
            params.C = s.C;
            y0 = 2*ones(size(s.a));
            
            obj = obj@otp.quadratic.QuadraticProblem(tspan, y0, params);
        end
    end
end
