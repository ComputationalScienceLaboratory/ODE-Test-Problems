classdef Canonical < otp.inverterchain.InverterChainProblem
    methods
        function obj = Canonical(varargin)
            p = inputParser;
            p.KeepUnmatched = true;
            p.addParameter('N', 50);
            p.parse(varargin{:});
            numMosfets = p.Results.N;
            
            y0 = zeros(numMosfets, 1);
            tspan = [0, round(24 + 0.6 * numMosfets)]; %ns

            unmatched = namedargs2cell(p.Unmatched);
            params = otp.inverterchain.InverterChainParameters('U0', 0, 'UIn', @uIn, 'UOp', 5, 'UT', 1, 'Gamma', 1, ...
                unmatched{:});
            
            obj = obj@otp.inverterchain.InverterChainProblem(tspan, y0, params);
            
            function u = uIn(t)
                if (t < 5)
                    u = 0;
                elseif (t >= 5 && t < 10)
                    u = t - 5;
                elseif (t >= 10 && t < 15)
                    u = 5;
                elseif (t >= 15 && t < 17)
                    u = -2.5 * t + 42.5;
                else
                    u = 0;
                end
            end
        end
        
    end
end