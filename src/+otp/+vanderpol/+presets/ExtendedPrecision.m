classdef ExtendedPrecision < otp.vanderpol.VanderpolProblem
    methods
        function obj = ExtendedPrecision(epsilon)
            if nargin < 1
                epsilon = sym(10^-6);
            end
            
            tspan = ([0, 1/2]);
            z0 = (epsilon.^(11:-1:0))*[1499571590693390159668/16677181699666569, ...
                              -7300255173432526840/617673396283947, ...
                              39058676403918956/22876792454961, ...
                              -231923508930412/847288609443, ...
                              515714746118/10460353203, ...
                              -3927188888/387420489, ...
                              34896076/14348907,...
                              -1121308/1594323, ...
                              15266/59049, ...
                              -292/2187, 10/81, -2/3].';
            y0 = [2; z0];
            
            
            params.epsilon = epsilon;
            obj = obj@otp.vanderpol.VanderpolProblem(tspan, y0, params); 

        end
    end
end
