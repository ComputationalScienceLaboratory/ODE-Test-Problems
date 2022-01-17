classdef ZlaKineticsProblem < otp.Problem
    methods
        function obj = ZlaKineticsProblem(timeSpan, y0, parameters)
            obj@otp.Problem('ZLA-Kinetics', 6, timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            k = obj.Parameters.k;
            K = obj.Parameters.K;
            klA = obj.Parameters.KlA;
            Ks = obj.Parameters.Ks;
            pCO2 = obj.Parameters.PCO2;
            H = obj.Parameters.H;
            
            obj.RHS = otp.RHS(@(t, y) otp.zlakinetics.f(t, y, k, K, klA, Ks, pCO2, H), ...
                'Jacobian', @(t, y) otp.zlakinetics.jacobian(t, y, k, K, klA, Ks, pCO2, H), ...
                'Mass', otp.zlakinetics.mass([], [], k, K, klA, Ks, pCO2, H), ...
                'MassSingular', 'yes', ...
                'Vectorized', 'on');
        end
        
    end
end
