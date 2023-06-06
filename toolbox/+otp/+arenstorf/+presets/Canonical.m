classdef Canonical < otp.arenstorf.ArenstorfProblem
    %CANONICAL One period of a satellite moving in an Earth-Moon system
    %   Source:
    %
    %   Hairer, Ernst, et al. Solving Ordinary Differential Equations I:
    %   Nonstiff Problems. 2nd ed., vol. 8, Springer-Verlag, 1993, pp. 129-130.
    %
    %   See also otp.arenstorf.ArenstorfProblem
    
    methods
        function obj = Canonical(mu)
            %CANONICAL Construct a canonical Arenstorf problem
            %   OBJ = CANONICAL(MU) Uses a Moon of mass MU. The time span and
            %   initial conditions use the same data type as MU. Single
            %   precision, vpa, and other types are supported.
            %
            %   OBJ = CANONICAL() Uses a MU corresponding to the Moon
    
            if nargin < 1
                mu = 0.012277471;
            end
            
            params = otp.arenstorf.ArenstorfParameters;
            params.Mu = mu;
            
            cls = class(mu);

            % Decimals converted to rational to support multiple data types
            y0 = [cast(497, cls) / cast(500, cls); ...
                cast(0, cls); ...
                cast(0, cls); ...
                cast(-823970832321143, cls) / cast(411659154384760, cls)];
            tspan = [cast(0, cls); ...
                cast(4541277234950502, cls) / cast(266113073862361, cls)];
            
            obj = obj@otp.arenstorf.ArenstorfProblem(tspan, y0, params);
        end

    end
end
