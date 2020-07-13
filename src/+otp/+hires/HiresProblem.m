classdef HiresProblem < otp.Problem
    
    methods
        function obj = HiresProblem(timeSpan, y0, parameters)
            obj@otp.Problem('HIRES', 8, timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            obj.Rhs = otp.Rhs(@otp.hires.f, ...
                otp.Rhs.FieldNames.Jacobian, @otp.hires.jacobian, ...
                otp.Rhs.FieldNames.JacobianVectorProduct, @otp.hires.jvp, ...
                otp.Rhs.FieldNames.JacobianAdjointVectorProduct, @otp.hires.javp);
        end
        
        function fig = internalPlot(obj, t, y, varargin)
            fig = internalPlot@otp.Problem(obj, t, y, 'xscale', 'log', 'yscale', 'log', varargin{:});
        end
    end
end
