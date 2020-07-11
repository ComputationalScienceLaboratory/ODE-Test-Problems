classdef TransistorAmplifierProblem < otp.Problem
    methods
        function obj = TransistorAmplifierProblem(timeSpan, y0, parameters)
            obj@otp.Problem('Transistor Amplifier', 8, timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            C = obj.Parameters.C;
            R = obj.Parameters.R;
            Ub = obj.Parameters.Ub;
            UF = obj.Parameters.UF;
            alpha = obj.Parameters.alpha;
            beta = obj.Parameters.beta;
            
            obj.Rhs = otp.Rhs(@(t, y) otp.transistoramplifier.f(t, y, C, R, Ub, UF, alpha, beta), ...
                otp.Rhs.FieldNames.Jacobian, @(t, y) otp.transistoramplifier.jac(t, y, C, R, Ub, UF, alpha, beta), ...
                otp.Rhs.FieldNames.Mass, otp.transistoramplifier.mass([], [], C, R, Ub, UF, alpha, beta), ...
                otp.Rhs.FieldNames.MassSingular, 'yes');
        end
        
        function validateNewState(obj, newTimeSpan, newY0, newParameters)
            validateNewState@otp.Problem(obj, newTimeSpan, newY0, newParameters)
            
            otp.utils.StructParser(newParameters) ...
                .checkField('C', 'real', 'finite', 'nonnegative') ...
                .checkField('R', 'real', 'finite', 'nonnegative') ...
                .checkField('Ub', 'scalar', 'real', 'finite', 'nonnegative') ...
                .checkField('UF', 'scalar', 'real', 'finite', 'nonnegative') ...
                .checkField('alpha', 'scalar', 'real', 'finite', 'nonnegative') ...
                .checkField('beta', 'scalar', 'real', 'finite', 'nonnegative');
        end
        
        function sol = internalSolve(obj, varargin)
            sol = internalSolve@otp.Problem(obj, 'Method', @ode15s, varargin{:});
        end
    end
end

