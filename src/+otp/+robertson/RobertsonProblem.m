classdef RobertsonProblem < otp.Problem
    methods
        function obj = RobertsonProblem(timeSpan, y0, parameters)
            obj@otp.Problem('Robertson Problem', 3, timeSpan, y0, parameters);
        end
    end
    
    methods (Access=protected)
        function onSettingsChanged(obj)
            k1 = obj.Parameters.K1;
            k2 = obj.Parameters.K2;
            k3 = obj.Parameters.K3;
            
            obj.Rhs = otp.Rhs(@(t, y) otp.robertson.f(t, y, k1, k2, k3), ...
                'Jacobian', @(t, y) otp.robertson.jac(t, y, k1, k2, k3), ...
                'NonNegative', 1:obj.NumVars);
        end
        
        function fig = internalPlot(obj, t, y, varargin)
            fig = internalPlot@otp.Problem(obj, t, y, 'xscale', 'log', varargin{:});
        end
        
        function mov = internalMovie(obj, t, y, varargin)
            mov = internalMovie@otp.Problem(obj, t, y, 'xscale', 'log', varargin{:});
        end
    end
end
