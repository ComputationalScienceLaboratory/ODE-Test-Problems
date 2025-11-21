classdef Canonical < otp.pendulumdae.PendulumDAEProblem
    %CANONICAL The constrained pendulum problem
    %
    % See
    %    Hairer, E., Roche, M., Lubich, C. (1989). Description of differential-algebraic problems. 
    %    In: The Numerical Solution of Differential-Algebraic Systems by Runge-Kutta Methods. 
    %    Lecture Notes in Mathematics, vol 1409. Springer, Berlin, Heidelberg. 
    %    https://doi.org/10.1007/BFb0093948
    
    methods
        function obj = Canonical
            tspan = [0; 10];
            
            params = otp.pendulumdae.PendulumDAEParameters;
            params.Mass = 1;
            params.Length = 1;
            params.Gravity = otp.utils.PhysicalConstants.EarthGravity;
            
            y0 = [sqrt(2)/2; sqrt(2)/2; 0; 0; 0; 0; 0];
            
            obj = obj@otp.pendulumdae.PendulumDAEProblem(tspan, y0, params);
        end
    end
end
