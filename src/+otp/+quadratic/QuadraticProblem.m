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
            
            obj.Rhs = otp.Rhs(@(~, x) otp.quadratic.f(x, a, B, C), ...
                otp.Rhs.FieldNames.Jacobian, @(~, x) otp.quadratic.jac(x, a, B, C));
        end
        
        function validateNewState(obj, newTimeSpan, newY0, newParameters)
            validateNewState@otp.Problem(obj, newTimeSpan, newY0, newParameters)
            % TODO
            %otp.utils.StructParser(newParameters).checkField('A', 'cell', ...
            %    @(A) all(cellfun(@(m) ismatrix(m) && isnumeric(m), A)));
        end
    end
end
