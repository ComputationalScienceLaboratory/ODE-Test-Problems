classdef QuasiGeostrophicROM < otp.quadratic.QuadraticProblem
    %QUASIGEOSTROPHICROM a quadratic reduced order model for the QG equations
    %
    % See:
    %    Popov, A. A., Mou, C., Sandu, A., & Iliescu, T. (2021). 
    %    A multifidelity ensemble Kalman filter with reduced order control variates. 
    %    SIAM Journal on Scientific Computing, 43(2), A1134-A1162.
    %
    methods
        function obj = QuasiGeostrophicROM(varargin)
            p = inputParser();
            p.addParameter('R', 50);
            p.parse(varargin{:});
            r = p.Results.R;
            
            s = load('PMISr100sp.mat');
            
            tspan = [0, 80/(365.25*20.12)];
            y0 = double(s.a0(1:r));
            params = otp.quadratic.QuadraticParameters( ...
                'A', double(s.b(1:r)), ...
                'B', double(s.A(1:r, 1:r)), ...
                'C', double(s.B(1:r, 1:r, 1:r)));
            
            obj = obj@otp.quadratic.QuadraticProblem(tspan, y0, params);
        end
    end

end
