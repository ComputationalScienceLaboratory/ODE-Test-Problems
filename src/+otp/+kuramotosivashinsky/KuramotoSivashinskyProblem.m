classdef KuramotoSivashinskyProblem < otp.Problem
    
    methods
        function obj = KuramotoSivashinskyProblem(timeSpan, y0, parameters)
            obj@otp.Problem('Kuramoto Sivashinsky Problem', [], timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            n = obj.Parameters.n;
            l = obj.Parameters.l;
            
            domain = [-l, l];
            D = otp.utils.pde.D(n, domain, 'C');
            L = otp.utils.pde.laplacian(n, domain, 1, 'C');
            
            obj.Rhs = otp.Rhs(@(t, u) otp.kuramotosivashinsky.f(t, u, D, L), ...
                otp.Rhs.FieldNames.Jacobian, @(t, u) otp.kuramotosivashinsky.jac(t, u, D, L));
            
        end
        
        function validateNewState(obj, newTimeSpan, newY0, newParameters)
            validateNewState@otp.Problem(obj, ...
                newTimeSpan, newY0, newParameters)
            
            otp.utils.StructParser(newParameters) ...
                .checkField('n', 'scalar', 'integer', 'finite', 'positive') ...
                .checkField('l', 'scalar', 'integer', 'finite', 'positive');
        end
    end
end
