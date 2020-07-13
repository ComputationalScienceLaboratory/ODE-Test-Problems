classdef AscherLinearDAEProblem < otp.Problem
    %Index-1 DAE problem
    % Problem description and fortran implementation can be found in
    % Ascher, Uri. "On symmetric schemes and differential-algebraic equations."
    % SIAM journal on scientific and statistical computing 10.5 (1989): 937-949.
    
    methods
        function obj = AscherLinearDAEProblem(timeSpan, y0, parameters)
            obj@otp.Problem('Ascher Linear DAE', 2, timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            beta = obj.Parameters.beta;
            
            obj.Rhs = otp.Rhs(@(t, y) otp.ascherlineardae.f(t, y, beta), ...
                otp.Rhs.FieldNames.Jacobian, @(t, y) otp.ascherlineardae.jac(t, y, beta), ...
                otp.Rhs.FieldNames.Mass, @(t) otp.ascherlineardae.mass(t, [], beta), ...
                otp.Rhs.FieldNames.MStateDependence, 'none', ...
                otp.Rhs.FieldNames.MassSingular, 'yes');
        end
        
        function validateNewState(obj, newTimeSpan, newY0, newParameters)
            validateNewState@otp.Problem(obj, newTimeSpan, newY0, newParameters)
            
            otp.utils.StructParser(newParameters) ...
                .checkField('beta', 'scalar', 'real', 'finite');
        end
    end
end

