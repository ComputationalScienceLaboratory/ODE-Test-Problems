classdef PopovSandu < otp.lorenz96.Lorenz96Problem
    
    % Used in https://doi.org/10.5194/npg-26-109-2019
    
    methods
        function obj = PopovSandu(varargin)
            
            p = inputParser;
            addParameter(p, 'Size', 40, @isscalar);
            addParameter(p, 'Partitions', 4, @isscalar);

            parse(p, varargin{:});
            
            s = p.Results;
            
            N = s.Size;
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
