classdef LienardProblem < otp.Problem
    %LIENARDPROBLEM a second order general forced oscillator system
    %
    % This problem solves equation of the form
    %
    %    x'' + f(x)x' + g(x) = p(t)
    %
    % as a first order system of equations
    %
    methods
        function obj = LienardProblem(timeSpan, y0, parameters)
            obj@otp.Problem('Lienard System', 2, timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            f  = obj.Parameters.F;
            df = obj.Parameters.DF;
            g  = obj.Parameters.G;
            dg = obj.Parameters.DG;
            p  = obj.Parameters.P;
            dp = obj.Parameters.DP;
            
            obj.RHS = otp.RHS(@(t, y) otp.lienard.f(t, y, f, df, g, dg, p, dp), ...
               'Jacobian', @(t, y) otp.lienard.jacobian(t, y, f, df, g, dg, p, dp), ...
                'Vectorized', 'on');
        end
    end
end

