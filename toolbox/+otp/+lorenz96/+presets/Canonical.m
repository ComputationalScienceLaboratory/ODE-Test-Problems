classdef Canonical < otp.lorenz96.Lorenz96Problem
    %CANONICAL This is the original problem presented in the literature.
    %  The initial condition is a slight perturbation of a critical point.
    %
    % See:
    %     Lorenz, E. N. (1996, September). Predictability: A problem partly solved. 
    %     In Proc. Seminar on predictability (Vol. 1, No. 1).
    methods
        function obj = Canonical(varargin)

            p = inputParser;
            p.addParameter('Size', 40, @isscalar);
            p.addParameter('Forcing', 8);

            p.parse(varargin{:});
            
            s = p.Results;
            
            n = s.Size;
            
            params = otp.lorenz96.Lorenz96Parameters;
            params.F = s.Forcing;
            
            % We initialise the Lorenz96 model as in (Lorenz & Emanuel 1998)
            
            y0 = 8*ones(n, 1);
            
            y0(floor(n/2)) = 8.008;
            
            % roughly ten years in system time
            tspan = [0, 720];
            
            obj = obj@otp.lorenz96.Lorenz96Problem(tspan, y0, params);
            
        end
    end
end
