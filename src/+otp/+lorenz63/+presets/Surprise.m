classdef Surprise < otp.lorenz63.Lorenz63Problem
    %SURPISE Strogatz's `surprise'
    %    Source:
    %      Strogatz, S. H. (2018). Nonlinear dynamics and chaos with student solutions manual: 
    %          With applications to physics, biology, chemistry, and
    %          engineering. CRC press. Page 351
    %
    methods
        function obj = Surprise
            %SURPRISE Construct a surprise Lorenz '63 problem
            %   OBJ = SURPRISE() defines the Lorenz '63
            %   problem with corresponding parameters
            %     sigma = 10, rho = 100, and beta = 8/3;
            %
            sigma = 10;
            rho   = 100;
            beta  = 8/3;

            params = otp.lorenz63.Lorenz63Parameters;
            params.Sigma = sigma;
            params.Rho   = rho;
            params.Beta  = beta;
            
            % Hand-picked initial conditions with the canonical timespan
            
            y0    = [2; 1; 1];
            tspan = [0 60];
            
            obj = obj@otp.lorenz63.Lorenz63Problem(tspan, y0, params);
        end
    end
end
