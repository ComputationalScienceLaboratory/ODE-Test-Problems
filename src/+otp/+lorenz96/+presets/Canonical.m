classdef Canonical < otp.lorenz96.Lorenz96Problem
    % [Name]
    %  Canonical
    %
    % [Description]
    %  This is the original problem presented in the literature.
    %  The initial condition is a slight perturbation of a critical point.
    %
    % [NoVars]
    %  40
    %
    % [Properties]
    %  Chaotic
    %
    % [Citation]
    %  (Lorenz & Emanuel 1996)
    %
    methods
        function obj = Canonical(varargin)

            p = inputParser;
            addParameter(p, 'Size', 40, @isscalar);
            addParameter(p, 'Forcing', 8, @(x) isnumeric(x) || isa(x, 'function_handle'));

            parse(p, varargin{:});
            
            s = p.Results;
            
            N = s.Size;
            F = s.Forcing;
            
            params.forcingFunction = F;
            
            % We initialise the Lorenz96 model as in (Lorenz & Emanuel 1998)
            
            y0 = 8*ones(N, 1);
            
            y0(floor(N/2)) = 8.008;
            
            % roughly ten years in system time
            tspan = [0, 720];
            
            obj = obj@otp.lorenz96.Lorenz96Problem(tspan, y0, params);
            
        end
    end
end
