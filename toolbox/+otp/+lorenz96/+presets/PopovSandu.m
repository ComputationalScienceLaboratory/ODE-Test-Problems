classdef PopovSandu < otp.lorenz96.Lorenz96Problem
    % A preset that has a cyclic forcing function that is different for
    % every variable. This preset was created for :cite:p:`PS19`.
    % This preset uses time span $t \in [0, 720]$, $N = 40$, $F=8$, 
    % four partitions, a forcing period of one time unit, and initial
    % conditions of $y_i = 8$ for all $i$ except for $y_20=8.008$. 
    
    methods
        function obj = PopovSandu(varargin)
            % Create a PopovSandu problem object.
            %
            % Parameters
            % ----------
            % Size : numeric(1, 1)
            %    The size of the problem as a positive integer.
            % Partitions : numeric(1, 1)
            %    The number of partitions into which to divide the
            %    variables.
            % ForcingPeriod : numeric(1, 1)
            %    The period of the forcing function in radians per unit
            %    time.
            %
            % Returns
            % -------
            % obj : PopovSandu
            %    The constructed problem.
            
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
