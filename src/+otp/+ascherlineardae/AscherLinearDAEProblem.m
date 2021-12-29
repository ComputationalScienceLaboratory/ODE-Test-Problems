classdef AscherLinearDAEProblem < otp.Problem
    %ASCHERLINEARDAEPROBLEM This is an Index-1 DAE problem
    %
    methods
        function obj = AscherLinearDAEProblem(timeSpan, y0, parameters)
            obj@otp.Problem('Ascher Linear DAE', 2, timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            beta = obj.Parameters.Beta;
            
            obj.Rhs = otp.Rhs(@(t, y) otp.ascherlineardae.f(t, y, beta), ...
                'Jacobian', @(t, y) otp.ascherlineardae.jac(t, y, beta), ...
                'Mass', @(t) otp.ascherlineardae.mass(t, [], beta), ...
                'MStateDependence', 'none', ...
                'MassSingular', 'yes');
        end
    end
end

