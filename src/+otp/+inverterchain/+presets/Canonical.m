classdef Canonical < otp.inverterchain.InverterChainProblem
    methods
        function obj = Canonical(numMosfets)
            if nargin < 1 || isempty(numMosfets)
                numMosfets = 50;
            end
            
            params = otp.inverterchain.InverterChainParameters;
            params.U0 = 0; % V
            params.UIn = @uIn;
            params.UOp = 5; % V
            params.UT = 1; % V
            params.Gamma = 1;
            
            y0 = zeros(numMosfets, 1);
            
            tspan = [0, round(24 + 0.6 * numMosfets)]; %ns
            
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