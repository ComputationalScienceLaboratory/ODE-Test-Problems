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
            
            obj.Rhs = otp.Rhs(@(~, x) otp.quadratic.f(t, x, a, B, C), ...
                otp.Rhs.FieldNames.Jacobian, @(t, x) otp.quadratic.jac(t, x, a, B, C), ...
                'JacobianParametera',  @(t, x) otp.quadratic.jacpara(t, x, a, B, C), ...
                'JacobianParameterB',  @(t, x) otp.quadratic.jacparaB(t, x, a, B, C), ...
                'JacobianParameterC',  @(t, x) otp.quadratic.jacparC(t, x, a, B, C));
        end
        
        function validateNewState(obj, newTimeSpan, newY0, newParameters)
            validateNewState@otp.Problem(obj, newTimeSpan, newY0, newParameters)
            % TODO
            %otp.utils.StructParser(newParameters).checkField('A', 'cell', ...
            %    @(A) all(cellfun(@(m) ismatrix(m) && isnumeric(m), A)));
        end
    end
end
