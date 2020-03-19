classdef Canonical < otp.hundsdorfer.HundsdorferProblem
    % TODO: add citation to paper
    
    methods
        function obj = Canonical(varargin)
            
            p = inputParser;
            addParameter(p, 'Size', 400, @isscalar);
            addParameter(p, 'k', [1E6,2E6], @isnumeric);
            addParameter(p, 'alpha', [1,0] , @isnumeric);
            addParameter(p, 's', [0,1] , @isnumeric);
            addParameter(p, 'x', [0,1] , @isnumeric);
                       
            parse(p, varargin{:});
            
            parsed = p.Results;
            
            params.np = parsed.Size;
            params.alpha = parsed.alpha;
            params.k = parsed.k;
            params.s = parsed.s;
            
            x = transpose(linspace(0,1,params.np));
            x(1)=[];
            
            params.x = x;
            params.bfun  = @(t)  (1-(sin(12*t))^4);
            
            u0 = 1 + params.s(2).*x;
            v0 = params.k(1)/params.k(2)*u0 + 1/params.k(2)*params.s(2);
            
            y0 = [u0;v0];

            tspan = [0, 1];
            
            obj = obj@otp.hundsdorfer.HundsdorferProblem(tspan, y0, params);
        end
    end
end
