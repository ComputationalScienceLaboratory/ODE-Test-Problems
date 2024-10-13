
classdef HIRESProblem < otp.Problem
    
    methods
        function obj = HIRESProblem(timeSpan, y0, parameters)
            obj@otp.Problem('HIRES', 8, timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            k1 = obj.Parameters.K1;
            k2 = obj.Parameters.K2;
            k3 = obj.Parameters.K3;
            k4 = obj.Parameters.K4;
            k5 = obj.Parameters.K5;
            k6 = obj.Parameters.K6;
            kPlus = obj.Parameters.KPlus;
            kMinus = obj.Parameters.KMinus;
            kStar = obj.Parameters.KStar;
            oks = obj.Parameters.OKS;

            obj.RHS = otp.RHS(@(t, y) otp.hires.f(t, y, k1, k2, k3, k4, k5, k6, kPlus, kMinus, kStar, oks), ...
                'Jacobian', @(t, y) otp.hires.jacobian(t, y, k1, k2, k3, k4, k5, k6, kPlus, kMinus, kStar, oks), ...
                'JacobianVectorProduct', @(t, y, v) ...
                otp.hires.jacobianVectorProduct(t, y, v, k1, k2, k3, k4, k5, k6, kPlus, kMinus, kStar, oks), ...
                'JacobianAdjointVectorProduct', @(t, y, v) ...
                otp.hires.jacobianAdjointVectorProduct(t, y, v, k1, k2, k3, k4, k5, k6, kPlus, kMinus, kStar, oks), ...
                'Vectorized', 'on');
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
