classdef Canonical < otp.lorenz96.Lorenz96Problem
    % Original Lorenz '96 preset presented in :cite:p:`Lor96` which uses time span $t ∈ [0, 720]$, $N = 40$, $F=8$, and
    % initial conditions of $y_i = 8$ for all $i$ except for $y_{⌊N/2⌋}=8.008$. 

    methods
        function obj = Canonical(varargin)
            % Create the Canonical Lorenz '96 problem object.
            %
            % Parameters
            % ----------
            % varargin
            %    A variable number of name-value pairs. The accepted names are
            %
            %    - ``N`` – The size of the problem as a positive integer.
            %    - ``Forcing`` – The forcing as a scalar, vector of N constants, or as a function.

            p = inputParser;
            p.addParameter('N', 40);
            p.parse(varargin{:});
            n = p.Results.N;
            
            % We initialise the Lorenz96 model as in (Lorenz & Emanuel 1998)
            y0 = 8*ones(n, 1);
            y0(floor(n/2)) = 8.008;
            
            % roughly ten years in system time
            tspan = [0, 720];

            unmatched = namedargs2cell(p.Unmatched);
            params = otp.lorenz96.Lorenz96Parameters('F', 8, unmatched{:});
            
            obj = obj@otp.lorenz96.Lorenz96Problem(tspan, y0, params);
        end
    end
end
