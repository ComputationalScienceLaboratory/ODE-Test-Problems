classdef ProtheroRobinsonProblem < otp.Problem
    % 
    % The Prothero-Robinson problem :cite:p:`PR74` is the linear ODE
    % 
    % $$y' = \lambda (y - \phi(t)) + \phi^{\prime}(t). $$
    %
    % It is used mainly for stability analysis of numerical time-stepping schemes. 
    % The exact solution is trivialy $y(t) = \phi(t)$ and therefore any 
    % errors introduced by the numerical scheme can be measured easily.
    % The parameter $\lambda$ controls the stifness of the problem.
    %
    % Notes
    % -----
    % +---------------------+-------------------------+
    % | Type                | DOE                     |
    % +---------------------+-------------------------+
    % | Number of Variables | 1                       |
    % +---------------------+-------------------------+
    % | Stiff               | yes                     |
    % +---------------------+-------------------------+
    %
    % Example
    % -------
    %
    % 
    % >>> p = otp.protherorobinson.presets.Canonical(-10);
    % >>> sol = p.solve();
    % >>> norm(p.solveExactly(sol.x) - sol.y)
    % 

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
        
        function y = internalSolveExactly(obj, t)
            if ~isequal(obj.Y0, obj.Parameters.Phi(obj.TimeSpan(1)))
                error('OTP:noExactSolution', ...
                    'An exact solution is unavailable for this initial condition');
            end
            
            y = obj.Parameters.Phi(t);
        end
    end
end
