classdef Canonical < otp.kuramotosivashinsky.KuramotoSivashinskyProblem
    
    methods
        function obj = Canonical(varargin)
            
            p = inputParser;
            addParameter(p, 'Size', 128);
            addParameter(p, 'L', 32*pi);

            parse(p, varargin{:});
            
            s = p.Results;
            
            N = s.Size;
            L = s.L;
            
            params.L = L;
            
            h=L/N;
            
            x=h*(1:N).';
            
            u0 = cos(x/16).*(1+sin(x/16));
            
            u0hat = fft(u0);

            tspan = [0, 100];
            
            obj = obj@otp.kuramotosivashinsky.KuramotoSivashinskyProblem(tspan, u0hat, params);
            
        end
    end
end
