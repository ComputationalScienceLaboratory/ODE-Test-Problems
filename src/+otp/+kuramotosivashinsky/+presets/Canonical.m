% The Kuramoto-Sivashinky equation is a chaotic problem.
%
% In this particular discretization, we are applying a spectral
% method, therefore the boundary conditions will be chosen to be as cyclic
% on the domain [0, L]. Note that this is different from another typical
% domain of [-L, L]. The larger the L, the more interesting the problem is
% but the more points are required to do a good discretization. The current
% canonical implementation with the size, L, and  is used in
%
% Kassam, Aly-Khan, and Lloyd N. Trefethen. 
% "Fourth-order time-stepping for stiff PDEs." 
% SIAM Journal on Scientific Computing 26, no. 4 (2005): 1214-1233.
%

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
            
            h = L/N;
            
            % exclude the left boundary point as it is identical to the
            % right boundary point
            x = linspace(h, L, N).';
            
            u0 = cospi(2*x/L).*(1+sinpi(2*x/L));
            
            u0hat = fft(u0);

            tspan = [0, 150];
            
            obj = obj@otp.kuramotosivashinsky.KuramotoSivashinskyProblem(tspan, u0hat, params);
            
        end
    end
end
