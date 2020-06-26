classdef ZLAKineticsProblem < otp.Problem
  %
  % Problem description and fortran implementation  can be found in
  % Francesca Mazzia, Cecilia Magherini and Felice Iavernaro
  % Test Set for Initial Value Problem Solvers, 2006
  % https://archimede.dm.uniba.it/~testset/report/chemakzo.pdf

    methods
        function obj = ZLAKineticsProblem(timeSpan, y0, parameters)
            obj@otp.Problem('ZLA Kinetics', 6, timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            k = obj.Parameters.k;
            K = obj.Parameters.K;
            KlA = obj.Parameters.KlA;
            pCO2 = obj.Parameters.pCO2;
            H = obj.Parameters.H;
            Ks = obj.Parameters.Ks;

            
            obj.Rhs = otp.Rhs(@(t, y) otp.zlakinetics.f(t, y, k, K, KlA, pCO2, H, Ks), ...
                otp.Rhs.FieldNames.Jacobian, @(t, y) otp.zlakinetics.jac(t, y, k, K, KlA, [], [], Ks), ...
                otp.Rhs.FieldNames.MassMatrix, otp.zlakinetics.mass([], [], [], [], [], [], [], []));     
        end
        
        function validateNewState(obj, newTimeSpan, newY0, newParameters)
            validateNewState@otp.Problem(obj, newTimeSpan, newY0, newParameters)
            
            otp.utils.StructParser(newParameters) ...
                .checkField('k', 'real', 'finite', 'nonnegative') ... 
                .checkField('K', 'scalar', 'real', 'finite', 'nonnegative') ... 
                .checkField('KlA', 'scalar', 'real', 'finite', 'nonnegative') ... 
                .checkField('pCO2', 'scalar', 'real', 'finite', 'nonnegative') ... 
                .checkField('H', 'scalar', 'real', 'finite') ...
                .checkField('Ks', 'scalar', 'real', 'finite', 'nonnegative'); 
        end
        
        function sol = internalSolve(obj, varargin)
            sol = internalSolve@otp.Problem(obj, 'Method', @ode15s, 'AbsTol', 1e-10, varargin{:});
        end
    end
end

