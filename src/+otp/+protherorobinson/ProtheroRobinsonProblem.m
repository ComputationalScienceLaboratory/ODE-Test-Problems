classdef ProtheroRobinsonProblem < otp.Problem
    methods
        function obj = ProtheroRobinsonProblem(timeSpan, y0, parameters)
            obj@otp.Problem('Prothero-Robinson', [], timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            lambda = obj.Parameters.Lambda;
            phi = obj.Parameters.Phi;
            dphi = obj.Parameters.DPhi;
            
            obj.RHS = otp.RHS(@(t, y) otp.protherorobinson.f(t, y, lambda, phi, dphi), ...
                'Jacobian', otp.protherorobinson.jacobian(lambda, phi, dphi));
        end
    end
end
