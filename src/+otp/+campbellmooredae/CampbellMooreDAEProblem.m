classdef CampbellMooreDAEProblem < otp.Problem
    % Originally Index-3 DAE problem reduced to index 1
    % Reference: Campbell, Stephen L., and Edward Moore. 
    % "Constraint preserving integrators for general nonlinear higher index DAEs."
    % Numerische Mathematik 69.4 (1995): 383-399.
    
    methods
        function obj = CampbellMooreDAEProblem(timeSpan, y0, parameters)
            obj@otp.Problem('Campbell-Moore DAE', 10, timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            r = obj.Parameters.r;
            rho = obj.Parameters.rho;
            
            obj.Rhs = otp.Rhs(@(t, y) otp.campbellmooredae.f(t, y, r,rho), ...
                otp.Rhs.FieldNames.Jacobian, @(t, y) otp.campbellmooredae.jac(t, y, r,rho), ...
                otp.Rhs.FieldNames.Mass,  otp.campbellmooredae.mass([], [], r,rho), ...
                otp.Rhs.FieldNames.MStateDependence, 'none', ...
                otp.Rhs.FieldNames.MassSingular, 'yes');
        end
        
        function validateNewState(obj, newTimeSpan, newY0, newParameters)
            validateNewState@otp.Problem(obj, newTimeSpan, newY0, newParameters)
            
            otp.utils.StructParser(newParameters) ...
                .checkField('rho', 'scalar', 'real', 'finite', 'positive');
            otp.utils.StructParser(newParameters) ...
                .checkField('r', 'scalar', 'real', 'finite', 'positive');
        end
    end
end

