classdef InverterChainProblem < otp.Problem
    methods
        function obj = InverterChainProblem(timeSpan, y0, parameters)
            obj@otp.Problem('Inverter Chain', [], timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)        
        function onSettingsChanged(obj)
            u0 = obj.Parameters.U0;
            uIn = obj.Parameters.UIn;
            uOp = obj.Parameters.UOp;
            uT = obj.Parameters.UT;
            gamma = obj.Parameters.Gamma;
            
            obj.RHS = otp.RHS( ...
                @(t,u) otp.inverterchain.f(t, u, u0, uIn, uOp, uT, gamma), ...
                'Jacobian', @(t, y) otp.inverterchain.jacobian( ...
                t, y, u0, uIn, uOp, uT, gamma));
        end
        
        function fig = internalPlot(obj, t, y, varargin)
            fig = internalPlot@otp.Problem(obj, t, y, ...
                'ylabel', 'Voltage', varargin{:});
        end
    end
end
