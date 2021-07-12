classdef HairerWanner < otp.kuramotosivashinsky.KuramotoSivashinskyProblem
    
    methods
        function obj = HairerWanner(varargin)
            
            p = inputParser;
            addParameter(p, 'Size', 1024);
            addParameter(p, 'L', 80*pi);

            parse(p, varargin{:});
            
            s = p.Results;
            
            N = s.Size;
            L = s.L;
            
            params.L = L;
            
            h = L/N;
            
            % exclude the left boundary point as it is identical to the
            % right boundary point
            x = linspace(h, L, N).';
            
            eta1 = min(x/L, 0.1 - x/L);
            eta2 = 20*(x/L - 0.2).*(0.3 - x/L);
            eta3 = min(x/L - 0.6, 0.7 - x/L);
            eta4 = min(x/L - 0.9, 1 - x/L);
            
            u0 = 16*max(0, max(eta1, max(eta2, max(eta3, eta4))));
            
            u0hat = fft(u0);

            tspan = [0, 100];
            
            obj = obj@otp.kuramotosivashinsky.KuramotoSivashinskyProblem(tspan, u0hat, params);
            
        end
    end
end
