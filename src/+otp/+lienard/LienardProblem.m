classdef LienardProblem < otp.Problem
    methods
        function obj = LienardProblem(timeSpan, y0, parameters)
            obj@otp.Problem('Lienard System', 2, timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            f  = obj.Parameters.f;
            df = obj.Parameters.df;
            g  = obj.Parameters.g;
            dg = obj.Parameters.dg;
            p  = obj.Parameters.p;
            dp = obj.Parameters.dp;
            
            obj.Rhs = otp.Rhs(@(t, y) otp.lienard.f(t, y, f, df, g, dg, p, dp), ...
                otp.Rhs.FieldNames.Jacobian, @(t, y) otp.lienard.jac(t, y, f, df, g, dg, p, dp));
        end
        
        function validateNewState(obj, newTimeSpan, newY0, newParameters)
            validateNewState@otp.Problem(obj, newTimeSpan, newY0, newParameters)
            
            otp.utils.StructParser(newParameters) ...
                .checkField('f', 'function') ...
                .checkField('df', 'function') ...
                .checkField('g', 'function') ...
                .checkField('dg', 'function') ...
                .checkField('p', 'function') ...
                .checkField('dp', 'function');
        end
        
        function sol = internalSolve(obj, varargin)
            sol = internalSolve@otp.Problem(obj, 'Method', @ode15s, varargin{:});
        end
    end
end

