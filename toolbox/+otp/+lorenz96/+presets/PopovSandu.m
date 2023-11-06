classdef PopovSandu < otp.lorenz96.Lorenz96Problem
    % A preset that has a cyclic forcing function that is different for every variable. This preset was created for
    % :cite:p:`PS19`. This preset uses time span $t ∈ [0, 720]$, $N = 40$, and initial conditions of $y_i = 8$ for all
    % $i$ except for $y_{⌊N/2⌋}=8.008$. The forcing as a function of time is given by
    %
    % $$
    % f(t) = 8 + 4\cos(2 π ω (t+\text{mod}(i - 1, q)/q))
    % $$
    %
    % where by default $q=4$ is the number of partitions, and $ω = 1$ is a forcing period of one time unit.
    
    methods
        function obj = PopovSandu(varargin)
            % Create the PopovSandu Lorenz '96 problem object.
            %
            % Parameters
            % ----------
            % varargin
            %    A variable number of name-value pairs. The accepted names are
            %
            %    - ``N`` – The size of the problem as a positive integer.
            %    - ``Partitions`` – The number of partitions into which to divide the variables.
            %    - ``ForcingPeriod`` – The period of the forcing function in radians per unit time.
            
            p = inputParser;
            p.addParameter('N', 40);
            p.addParameter('Partitions', 4);
            p.addParameter('ForcingPeriod', 1); % default corresponds to 5 days
            p.parse(varargin{:});
            
            n = p.Results.N;
            q = p.Results.Partitions;
            omega = p.Results.ForcingPeriod;
            
            params = otp.lorenz96.Lorenz96Parameters('F', @(t) 8 + 4*cos(2*pi*omega*(t + mod((1:n) - 1, q)/q)).');
            
            % We initialise the Lorenz96 model as in (Lorenz & Emanuel 1998)
            
            y0 = 8*ones(n, 1);
            y0(floor(n/2)) = 8.008;
            
            tspan = [0, 720]; % 3600 days
            
            obj = obj@otp.lorenz96.Lorenz96Problem(tspan, y0, params);
        end
    end
end
