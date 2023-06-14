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
            
            obj.RHS = otp.RHS(@(t, y) otp.ascherlineardae.f(t, y, beta), ...
                'Jacobian', @(t, y) otp.ascherlineardae.jacobian(t, y, beta), ...
                'Mass', @(t) otp.ascherlineardae.mass(t, [], beta), ...
                'MStateDependence', 'none', ...
                'MassSingular', 'yes');
        end
        
        function y = internalSolveExactly(obj, t)
            beta = obj.Parameters.Beta;
            if ~isequal(obj.Y0, [1; beta])
                error('OTP:noExactSolution', ...
                    'An exact solution is unavailable for this initial condition');
            end
            
            y = [t .* sin(t) + (1 + beta * t) .* exp(-t); ...
                beta * exp(-t) + sin(t)];
        end
        
        function sol = internalSolve(obj, varargin)
            sol = internalSolve@otp.Problem(obj, ...
                'Solver', otp.utils.Solver.StiffNonConstantMass, varargin{:});
        end
    end
end

