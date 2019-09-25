classdef Canonical < otp.inverterchain.InverterChainProblem
    methods
        function obj = Canonical(numMosfets)
            if nargin < 1
                numMosfets = 50;
            end
            
            params.u0 = 0; % V
            params.uIn = @uIn;
            params.uOp = 5; % V
            params.uT = 1; % V
            params.gamma = 1;
            
            y0 = zeros(numMosfets, 1);
            
            tspan = [0, round(24 + 0.6 * numMosfets)]; %ns
            
            obj = obj@otp.inverterchain.InverterChainProblem(tspan, y0, params);
        end
        
    end
end

function Uin = uIn(t)

% define a piecewise function for Uin - the input voltage
% Replicates figure 6
if (t < 5)
    Uin = 0;
elseif (t >= 5 && t < 10)
    Uin = t - 5;
elseif (t >= 10 && t < 15)
    Uin = 5;
elseif (t >= 15 && t < 17)
    Uin = -2.5 * t + 42.5;
else
    Uin = 0;
end

end