classdef InverterChainProblem < otp.Problem
    methods
        function obj = InverterChainProblem(timeSpan, y0, parameters)
            obj@otp.Problem('Inverter Chain', [], timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function fig = internalPlot(obj, t, y, varargin)
            fig = internalPlot@otp.Problem(obj, t, y, 'ylabel', 'Voltage', varargin{:});
        end
        
        function onSettingsChanged(obj)
            u0 = obj.Parameters.u0;
            uIn = obj.Parameters.uIn;
            uOp = obj.Parameters.uOp;
            uT = obj.Parameters.uT;
            gamma = obj.Parameters.gamma;
            
            obj.Rhs = otp.Rhs(@(t,u) otp.inverterchain.f(t, u, u0, uIn, uOp, uT, gamma), ...
                otp.Rhs.FieldNames.Jacobian, @(t, y) otp.inverterchain.jac(t, y, u0, uIn, uOp, uT, gamma));
        end
        
        function validateNewState(obj, newTimeSpan, newY0, newParameters)
            validateNewState@otp.Problem(obj, ...
                newTimeSpan, newY0, newParameters)
            
            otp.utils.StructParser(newParameters) ...
                .checkField('u0', 'scalar', 'real', 'finite', 'nonnegative') ...
                .checkField('uIn', 'function') ...
                .checkField('uOp', 'scalar', 'real', 'finite', 'positive') ...
                .checkField('uT', 'scalar', 'real', 'finite', 'positive') ...
                .checkField('gamma', 'scalar', 'real', 'finite', 'positive');
        end
    end
end
