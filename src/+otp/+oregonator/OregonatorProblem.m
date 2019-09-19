classdef OregonatorProblem < otp.Problem
    methods
        function obj = OregonatorProblem(timeSpan, y0, parameters)
            obj@otp.Problem('Oregonator', 3, timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            obj.Rhs = otp.Rhs(@otp.oregonator.f, ...
                otp.Rhs.FieldNames.Jacobian, @otp.oregonator.jac);
        end
        
        function fig = internalPlot(obj, t, y, varargin)
            fig = internalPlot@otp.Problem(obj, t, y, 'yscale', 'log', varargin{:});
        end
        
        function sol = internalSolve(obj, varargin)
            sol = internalSolve@otp.Problem(obj, 'Method', @ode15s, varargin{:});
        end
    end
end

