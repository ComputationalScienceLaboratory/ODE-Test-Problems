classdef E5Problem < otp.Problem
    methods
        function obj = E5Problem(timeSpan, y0, parameters)
            obj@otp.Problem('E5', 4, timeSpan, y0, parameters);
        end
    end
    
    methods (Access=protected)
        function validateNewState(obj, newTimeSpan, newY0, newParameters)
            validateNewState@otp.Problem(obj, newTimeSpan, newY0, newParameters);
            
            otp.utils.StructParser(newParameters) ...
                .checkField('A', 'scalar', 'real', 'finite', 'positive') ...
                .checkField('B', 'scalar', 'real', 'finite', 'positive') ...
                .checkField('C', 'scalar', 'real', 'finite', 'positive') ...
                .checkField('M', 'scalar', 'real', 'finite', 'positive');
        end
        
        function onSettingsChanged(obj)
            A = obj.Parameters.A;
            B = obj.Parameters.B;
            C = obj.Parameters.C;
            M = obj.Parameters.M;
            
            obj.Rhs = otp.Rhs(@(t, y) otp.e5.f(t, y, A, B, C, M), ...
                otp.Rhs.FieldNames.Jacobian, @(t, y) otp.e5.jac(t, y, A, B, C, M));
        end
        
        function fig = internalPlot(obj, t, y, varargin)
            fig = internalPlot@otp.Problem(obj, t, y, ...
                'xscale', 'log', 'yscale', 'log', varargin{:});
        end
        
        function sol = internalSolve(obj, varargin)
            sol = internalSolve@otp.Problem(obj, 'Method', @ode15s, varargin{:});
        end
    end
end
