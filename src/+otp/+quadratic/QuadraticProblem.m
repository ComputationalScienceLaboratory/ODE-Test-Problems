classdef QuadraticProblem < otp.Problem
    
    methods
        function obj = QuadraticProblem(timeSpan, y0, parameters)
            obj@otp.Problem('Quadratic Problem', [], timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            a = obj.Parameters.a;
            B = obj.Parameters.B;
            C = obj.Parameters.C;
            
            obj.Rhs = otp.Rhs(@(t, x) otp.quadratic.f(t, x, a, B, C), ...
                otp.Rhs.FieldNames.Jacobian, @(t, x) otp.quadratic.jac(t, x, a, B, C), ...
                'PartialDerivativea',  @(t, x) otp.quadratic.pda(t, x, a, B, C), ...
                'PartialDerivativeB',  @(t, x) otp.quadratic.pdb(t, x, a, B, C), ...
                'PartialDerivativeC',  @(t, x) otp.quadratic.pdc(t, x, a, B, C));
        end
        
        function validateNewState(obj, newTimeSpan, newY0, newParameters)
            validateNewState@otp.Problem(obj, newTimeSpan, newY0, newParameters);
            
            otp.utils.StructParser(newParameters) ...
                .checkField('a', 'column', 'numeric', 'finite') ...
                .checkField('B', 'matrix', 'numeric', 'finite') ...
                .checkField('C', '3-tensor', 'numeric', 'finite');
        end
    end
end
