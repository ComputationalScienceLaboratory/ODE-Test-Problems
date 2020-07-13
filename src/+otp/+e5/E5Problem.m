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
                otp.Rhs.FieldNames.Jacobian, @(t, y) otp.e5.jac(t, y, A, B, C, M), ...
                otp.Rhs.FieldNames.NonNegative, 1:obj.NumVars);
        end
        
        function fig = internalPlot(obj, t, y, varargin)
            fig = internalPlot@otp.Problem(obj, t, y, ...
                'xscale', 'log', 'yscale', 'log', varargin{:});
        end
        
        function sol = internalSolve(obj, varargin)
            % Set tolerances due to the very small scales
            sol = internalSolve@otp.Problem(obj, 'AbsTol', 1e-50, 'RelTol', 1e-10, varargin{:});
        end
    end
end
