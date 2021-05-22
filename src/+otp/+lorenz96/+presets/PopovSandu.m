classdef PopovSandu < otp.lorenz96.Lorenz96Problem
    % [Name]
    %  Time-dependent Forcing
    %
    % [Description]
    %  Used in (Popov and Sandu, 2019)
    %
    % [NoVars]
    %  40
    %
    % [Properties]
    %  Chaotic
    %
    methods
        function obj = PopovSandu(varargin)
            
            p = inputParser;
            p.KeepUnmatched = true;
            addParameter(p, 'Size', 40, @isscalar);

            parse(p, varargin{:});
            
            s = p.Results;
            
            N = s.Size;
            
            pu = p.Unmatched;
            
            p = inputParser;
            p.KeepUnmatched = true;
            p.addParameter('Partitions', (mod(N, 4) == 0)*4 + (mod(N, 4) ~= 0)*1, @(x) mod(N, x) == 0);
            p.parse(pu);
            
            s = p.Results;
            
            q = s.Partitions;
            
            fiveDays = 1;
            omega    = 2 * pi/(fiveDays);
            
            F = @(t) 8 + 4*cos(omega*(t + mod((1:N) - 1, q)/q)).';
            
            params.forcingFunction = F;            
            
            % We initialise the Lorenz96 model as in (Lorenz & Emanuel 1998)
            
            y0 = 8*ones(N, 1);
            
            y0(floor(N/2)) = 8.008;
            
            tspan = [0, 720]; % 3600 days
            
            obj = obj@otp.lorenz96.Lorenz96Problem(tspan, y0, params);
            
        end
    end
end
