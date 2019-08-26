classdef RobertsonProblem < otp.Problem
    methods
        function obj = RobertsonProblem(timeSpan, y0, parameters)
            obj@otp.Problem('Robertson Problem', timeSpan, y0, parameters);
        end
    end
    
    methods (Access=protected)
        function validateNewState(obj, newTimeSpan, newY0, newParameters)
            validateNewState@otp.Problem(obj, newTimeSpan, newY0, newParameters);
            
            otp.utils.StructParser(newParameters) ...
                .checkField('k1', 'scalar', 'real', 'finite', 'positive') ...
                .checkField('k2', 'scalar', 'real', 'finite', 'positive') ...
                .checkField('k3', 'scalar', 'real', 'finite', 'positive');
        end
        
        function onSettingsChanged(obj)
            k1 = obj.Parameters.k1;
            k2 = obj.Parameters.k2;
            k3 = obj.Parameters.k3;
            
            obj.Rhs = otp.Rhs(@(t, y) otp.robertson.f(t, y, k1, k2, k3), ...
                otp.Rhs.FieldNames.Jacobian, @(t, y) otp.robertson.jac(t, y, k1, k2, k3));
        end
        
        function fig = internalPlot(obj, t, y, varargin)
            fig = internalPlot@otp.Problem(obj, t, y, 'xscale', 'log', varargin{:});
        end
        
        function sol = internalSolve(obj, varargin)
            sol = internalSolve@otp.Problem(obj, 'Method', @ode15s, varargin{:});
        end
    end
end
