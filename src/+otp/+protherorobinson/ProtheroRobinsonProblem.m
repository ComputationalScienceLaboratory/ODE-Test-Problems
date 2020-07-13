classdef ProtheroRobinsonProblem < otp.Problem
    methods
        function obj = ProtheroRobinsonProblem(timeSpan, y0, parameters)
            obj@otp.Problem('Prothero-Robinson', [], timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            lambda = obj.Parameters.lambda;
            phi = obj.Parameters.phi;
            dphi = obj.Parameters.dphi;
            
            obj.Rhs = otp.Rhs(@(t, y) otp.protherorobinson.f(t, y, lambda, phi, dphi), ...
                otp.Rhs.FieldNames.Jacobian, @(t, y) otp.protherorobinson.jac(t, y, lambda, phi, dphi));
        end
        
        function validateNewState(obj, newTimeSpan, newY0, newParameters)
            validateNewState@otp.Problem(obj, newTimeSpan, newY0, newParameters)
            
            otp.utils.StructParser(newParameters) ...
                .checkField('lambda', 'finite', 'matrix', 'numeric') ...
                .checkField('phi', 'function') ...
                .checkField('dphi', 'function');
        end
    end
end
