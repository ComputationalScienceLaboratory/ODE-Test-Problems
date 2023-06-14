classdef OregonatorProblem < otp.Problem
    methods
        function obj = OregonatorProblem(timeSpan, y0, parameters)
            obj@otp.Problem('Oregonator', 3, timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            obj.RHS = otp.RHS(@otp.oregonator.f, ...
                'Jacobian', @otp.oregonator.jacobian, ...
                'Vectorized', 'on');
        end
        
        function fig = internalPlot(obj, t, y, varargin)
            fig = internalPlot@otp.Problem(obj, t, y, ...
                'yscale', 'log', varargin{:});
        end
        
        function mov = internalMovie(obj, t, y, varargin)
            mov = internalMovie@otp.Problem(obj, t, y, ...
                'yscale', 'log', varargin{:});
        end
    end
end

