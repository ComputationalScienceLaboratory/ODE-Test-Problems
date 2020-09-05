classdef Canonical < otp.kuramotosivashinsky.KuramotoSivashinskyProblem
    
    methods
        function obj = Canonical(varargin)
            
            p = inputParser;
            addParameter(p, 'Size', 64, @isscalar);
            addParameter(p, 'L', 25, @isscalar);

            parse(p, varargin{:});
            
            s = p.Results;
            
            n = s.Size;
            
            
            params.n = n;
            params.l = s.L;
            
            x = linspace(0, 10*pi, n + 1);
            
            u0 = 4*cos(x(1:end-1)).';

            tspan = [0, 100];
            
            obj = obj@otp.kuramotosivashinsky.KuramotoSivashinskyProblem(tspan, u0, params);
        end
    end
end
