classdef Canonical < otp.quadratic.QuadraticProblem
    methods
        function obj = Canonical(varargin)
            tspan = [0, 10];
            
            p = inputParser;
            addParameter(p, 'a', 0);
            addParameter(p, 'B', 1);
            addParameter(p, 'C', -1);

            parse(p, varargin{:});
            
            s = p.Results;
            
            params.a = s.a;
            params.B = s.B;
            params.C = s.C;
            y0 = 2*ones(size(s.a));
            
            obj = obj@otp.quadratic.QuadraticProblem(tspan, y0, params);
        end
    end
end
