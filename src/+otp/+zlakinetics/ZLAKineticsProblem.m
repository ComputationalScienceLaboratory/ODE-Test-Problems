classdef ZLAKineticsProblem < otp.Problem
    methods
        function obj = ZLAKineticsProblem(timeSpan, y0, parameters)
            obj@otp.Problem('ZLA Kinetics', 6, timeSpan, y0, parameters);
        end
        
        function fig = loglog(obj, varargin)
            fig = obj.plot(varargin{:}, 'xscale', 'log', 'yscale', 'log');
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            k = obj.Parameters.k;
            K = obj.Parameters.K;
            klA = obj.Parameters.klA;
            Ks = obj.Parameters.Ks;
            pCO2 = obj.Parameters.pCO2;
            H = obj.Parameters.H;
            
            obj.Rhs = otp.Rhs(@(t, y) otp.zlakinetics.f(t, y, k, K, klA, Ks, pCO2, H), ...
                otp.Rhs.FieldNames.Jacobian, @(t, y) otp.zlakinetics.jac(t, y, k, K, klA, Ks, pCO2, H), ...
                otp.Rhs.FieldNames.Mass, otp.zlakinetics.mass([], [], k, K, klA, Ks, pCO2, H), ...
                otp.Rhs.FieldNames.MassSingular, 'yes');
        end
        
        function validateNewState(obj, newTimeSpan, newY0, newParameters)
            validateNewState@otp.Problem(obj, newTimeSpan, newY0, newParameters)
            
            otp.utils.StructParser(newParameters) ...
                .checkField('k', 'real', 'finite', 'nonnegative', @(k) length(k) == 4) ...
                .checkField('K', 'scalar', 'real', 'finite', 'nonnegative') ...
                .checkField('klA', 'scalar', 'real', 'finite', 'nonnegative') ...
                .checkField('Ks', 'scalar', 'real', 'finite', 'nonnegative') ...
                .checkField('pCO2', 'scalar', 'real', 'finite', 'nonnegative') ...
                .checkField('H', 'scalar', 'real', 'finite', 'nonnegative');
        end
    end
end
