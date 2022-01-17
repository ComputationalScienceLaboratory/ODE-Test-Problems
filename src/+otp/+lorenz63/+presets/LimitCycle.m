classdef LimitCycle < otp.lorenz63.Lorenz63Problem
    %LIMITCYCLE A non-chaotic set of parameters for the problem to showcase potential periodic behavior.
    %    Source:
    %      Strogatz, S. H. (2018). Nonlinear dynamics and chaos with student solutions manual: 
    %          With applications to physics, biology, chemistry, and
    %          engineering. CRC press. Page 341
    %
    methods
        function obj = LimitCycle
            %LIMITCYCLE Construct a limit cycle Lorenz '63 problem
            %   OBJ = LIMITCYCLE() defines the Lorenz '63
            %   problem with corresponding parameters
            %     sigma = 10, rho = 350, and beta = 8/3;
            %
            sigma = 10;
            rho   = 350;
            beta  = 8/3;
    
            params = otp.lorenz63.Lorenz63Parameters;
            params.Sigma = sigma;
            params.Rho   = rho;
            params.Beta  = beta;
            
            % We will use Lorenz's initial conditions and timespan as Strogatz
            % does not specify those in his book.
            
            y0    = [0; 1; 0];
            tspan = [0 60];
            
            obj = obj@otp.lorenz63.Lorenz63Problem(tspan, y0, params);            
        end
    end
end
