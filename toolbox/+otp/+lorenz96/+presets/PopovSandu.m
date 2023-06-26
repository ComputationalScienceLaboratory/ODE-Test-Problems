classdef PopovSandu < otp.lorenz96.Lorenz96Problem
    %POPOVSANDU
    % Used in https://doi.org/10.5194/npg-26-109-2019
    
    methods
        function obj = PopovSandu(varargin)
            
            p = inputParser;
            
            p.addParameter('Size', 40, @isscalar);
            p.addParameter('Partitions', 4, @isscalar);
            p.addParameter('ForcingPeriod', 1, @isscalar); % default corresponds to 5 days

            p.parse(varargin{:});
            
            s = p.Results;
            
            n = s.Size;
            q = s.Partitions;
            omega = s.ForcingPeriod;
           
            F = @(t) 8 + 4*cos(2*pi*omega*(t + mod((1:n) - 1, q)/q)).';
            
            params = otp.lorenz96.Lorenz96Parameters;
            params.F = F;            
            
            % We initialise the Lorenz96 model as in (Lorenz & Emanuel 1998)
            
            y0 = 8*ones(n, 1);
            
            y0(floor(n/2)) = 8.008;
            
            tspan = [0, 720]; % 3600 days
            
            obj = obj@otp.lorenz96.Lorenz96Problem(tspan, y0, params);
            
        end
    end
end
