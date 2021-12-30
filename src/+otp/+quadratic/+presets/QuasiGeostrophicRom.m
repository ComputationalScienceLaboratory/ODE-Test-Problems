classdef QuasiGeostrophicRom < otp.quadratic.QuadraticProblem
    %QUASIGEOSTROPHICROM a quadratic reduced order model for the QG equations
    %
    % See:
    %    Popov, A. A., Mou, C., Sandu, A., & Iliescu, T. (2021). 
    %    A multifidelity ensemble Kalman filter with reduced order control variates. 
    %    SIAM Journal on Scientific Computing, 43(2), A1134-A1162.
    %
    methods
        function obj = QuasiGeostrophicRom(r)
            tspan = [0, 80/(365.25*20.12)];
            
            if nargin < 1
                r = 50;
            end   
            
            s = load('PMISr100sp.mat');
            
            params = otp.quadratic.QuadraticParameters;
            params.A = double(s.b(1:r));
            params.B = double(s.A(1:r, 1:r));
            params.C = double(s.B(1:r, 1:r, 1:r));
            y0 = double(s.a0(1:r));
            
            obj = obj@otp.quadratic.QuadraticProblem(tspan, y0, params);
        end
    end

end
