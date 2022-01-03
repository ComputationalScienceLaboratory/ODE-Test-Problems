classdef HIRESProblem < otp.Problem
    
    methods
        function obj = HIRESProblem(timeSpan, y0, parameters)
            obj@otp.Problem('HIRES', 8, timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            obj.Rhs = otp.Rhs(@otp.hires.f, ...
                'Jacobian', @otp.hires.jacobian, ...
                'JacobianVectorProduct', @otp.hires.jvp, ...
                'JacobianAdjointVectorProduct', @otp.hires.javp);
        end
        
        function fig = internalPlot(obj, t, y, varargin)
            fig = internalPlot@otp.Problem(obj, t, y, ...
                'xscale', 'log', 'yscale', 'log', varargin{:});
        end
        
        function mov = internalMovie(obj, t, y, varargin)
            mov = internalMovie@otp.Problem(obj, t, y, ...
                'xscale', 'log', 'yscale', 'log', varargin{:});
        end
    end
end
