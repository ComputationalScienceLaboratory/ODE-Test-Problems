classdef CUSPProblem < otp.Problem
    % See Hairer and Wanner, Solving ODEs II, p. 147
    
    methods
        function obj = CUSPProblem(timeSpan, y0, parameters)
            obj@otp.Problem('CUSP Problem', [], ...
                timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            
            N       = obj.Parameters.N;
            epsilon = obj.Parameters.epsilon;
            sigma   = obj.Parameters.sigma;
            
            domain = [0, 1];
            
            L = otp.utils.pde.laplacian(N, domain, sigma, 'C');
            
            obj.Rhs = otp.Rhs(@(t, y) otp.cusp.f(t, y, epsilon, L), ...
                otp.Rhs.FieldNames.Jacobian, @(t, y) otp.cusp.jac(t, y, epsilon, L));

        end
        
        function validateNewState(obj, newTimeSpan, newY0, newParameters)
            
            validateNewState@otp.Problem(obj, ...
                newTimeSpan, newY0, newParameters)
            
            otp.utils.StructParser(newParameters) ...
                .checkField('epsilon', 'finite', 'positive') ...
                .checkField('sigma', 'finite', 'positive');
            
        end
    end
end